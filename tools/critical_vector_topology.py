"""Bounded TASM/TLINK probe for the 1534:003C/0045 wrapper/helper boundary."""
from common import ROOT, sha, write_json
from dos import dos
from extract import mz, extract
import json
import re


WRAPPER = bytes.fromhex('b024ba0600e80100cb')
HELPER = bytes.fromhex('1e0e1fb425cd211fc3')
TAIL = WRAPPER + HELPER
PREFIX_BYTES = 0x3C
VARIANTS = {
    'combined_byte': ('byte', False),
    'split_byte': ('byte', True),
    'split_word': ('word', True),
    'split_para': ('para', True),
}


def verify_pins():
    input_manifest = json.loads((ROOT / 'metadata' / 'inputs.json').read_text(encoding='utf-8'))
    checked = {}
    for record in input_manifest['files']:
        path = ROOT / record['path']
        data = path.read_bytes()
        actual = {'size': len(data), 'sha256': sha(data)}
        expected = {'size': record['size'], 'sha256': record['sha256']}
        if actual != expected:
            raise RuntimeError(f"Input pin mismatch for {record['path']}: {actual} != {expected}")
        checked[record['path']] = actual

    lock = json.loads((ROOT / 'metadata' / 'toolchain-lock.json').read_text(encoding='utf-8'))
    wanted = {
        'toolchain/TASM.EXE', 'toolchain/TLINK.EXE',
        'toolchain/nmlgcdos/msdos.exe', 'toolchain/msdos-i86/msdos.exe',
    }
    tool_pins = {}
    for record in lock['files']:
        if record['path'] not in wanted:
            continue
        data = (ROOT / record['path']).read_bytes()
        actual = {'size': len(data), 'sha256': sha(data)}
        expected = {'size': record['size'], 'sha256': record['sha256']}
        if actual != expected:
            raise RuntimeError(f"Tool pin mismatch for {record['path']}: {actual} != {expected}")
        tool_pins[record['path']] = actual
    if set(tool_pins) != wanted:
        raise RuntimeError(f'Incomplete tool pins: {sorted(set(tool_pins) ^ wanted)}')
    return {'inputs': checked, 'tools': tool_pins}


def main_source(split):
    external = 'EXTRN HELPER:NEAR\n' if split else ''
    define_helper = '' if split else f'PUBLIC HELPER\nHELPER:\n    push ds\n    push cs\n    pop ds\n    mov ah, 25h\n    int 21h\n    pop ds\n    ret\n'
    return (
        '.8086\n' + external +
        "CODE segment byte public 'CODE'\nASSUME CS:CODE\n" +
        'PUBLIC START\nSTART:\n    db 60 dup (0)\n' +
        'PUBLIC WRAPPER\nWRAPPER:\n    mov al, 24h\n    mov dx, 6\n    call HELPER\n    retf\n' +
        define_helper + 'CODE ends\nend START\n'
    )


def helper_source(alignment):
    return (
        '.8086\n' + f"CODE segment {alignment} public 'CODE'\n" +
        'ASSUME CS:CODE\nPUBLIC HELPER\nHELPER:\n' +
        '    push ds\n    push cs\n    pop ds\n    mov ah, 25h\n' +
        '    int 21h\n    pop ds\n    ret\n' +
        'CODE ends\nend\n'
    )


def map_public_symbols(text):
    # Keep the exact MAP as a build artifact too; this extracts commonly emitted
    # segment:offset/name rows without assuming a particular decorative header.
    rows = []
    for line in text.splitlines():
        match = re.search(r'\b([0-9A-F]{4}):([0-9A-F]{4})\s+([A-Za-z_?$@][\w?$@]*)\b', line, re.I)
        if match and match.group(3).upper() in {'START', 'WRAPPER', 'HELPER'}:
            rows.append({'segment': int(match.group(1), 16), 'offset': int(match.group(2), 16),
                         'symbol': match.group(3)})
    return rows


def map_segment_rows(text):
    rows = []
    for line in text.splitlines():
        match = re.match(r'\s*([0-9A-F]{5})H\s+([0-9A-F]{5})H\s+([0-9A-F]{5})H\s+(\S+)\s+(\S+)\s*$', line, re.I)
        if match:
            rows.append({'start': int(match.group(1), 16), 'stop_inclusive': int(match.group(2), 16),
                         'length': int(match.group(3), 16), 'name': match.group(4), 'class': match.group(5)})
    return rows


def run_variant(name, alignment, split, out_root):
    folder = out_root / name
    folder.mkdir(parents=True, exist_ok=True)
    for artifact in ('M0.OBJ','M1.OBJ','OUT.EXE','OUT.MAP'):
        (folder / artifact).unlink(missing_ok=True)
    (folder / 'M0.ASM').write_text(main_source(split), encoding='ascii')
    objects = ['M0.OBJ']
    logs = [dos('TASM.EXE', ['M0.ASM,M0.OBJ,M0.LST'], folder)]
    if split:
        (folder / 'M1.ASM').write_text(helper_source(alignment), encoding='ascii')
        logs.append(dos('TASM.EXE', ['M1.ASM,M1.OBJ,M1.LST'], folder))
        objects.append('M1.OBJ')
    logs.append(dos('TLINK.EXE', ['+'.join(objects) + ',OUT.EXE,OUT.MAP'], folder))
    (folder / 'tools.log').write_text('\n'.join(logs), encoding='cp437')
    exe = (folder / 'OUT.EXE').read_bytes()
    header, image, relocs, overlay = mz(exe)
    map_text = (folder / 'OUT.MAP').read_text(encoding='cp437', errors='replace')
    # The near-call displacement changes with contribution alignment, so locate
    # the stable five-byte wrapper prefix and record the displacement separately.
    wrapper_at = image.find(WRAPPER[:5])
    helper_at = image.find(HELPER)
    if wrapper_at < 0 or helper_at < 0:
        raise AssertionError(f'{name}: wrapper/helper signature not found')
    displacement = int.from_bytes(image[wrapper_at + 6:wrapper_at + 8], 'little', signed=True)
    wrapper_end = wrapper_at + len(WRAPPER)
    region = image[PREFIX_BYTES:PREFIX_BYTES + len(TAIL)]
    return {
        'alignment': alignment,
        'split': split,
        'object_order': objects,
        'module_size': len(image),
        'module_sha256': sha(image),
        'module_hex': image.hex(),
        'wrapper_offset_by_bytes': wrapper_at,
        'helper_offset_by_bytes': helper_at,
        'expected_wrapper_offset': PREFIX_BYTES,
        'expected_helper_offset': PREFIX_BYTES + len(WRAPPER) if alignment == 'byte' else
                                  (PREFIX_BYTES + 0x0A if alignment == 'word' else PREFIX_BYTES + 0x14),
        'near_call': {
            'instruction_offset': wrapper_at + 5,
            'next_ip': wrapper_at + 8,
            'signed_displacement': displacement,
            'resolved_target_offset': wrapper_at + 8 + displacement,
            'target_matches_helper_offset': wrapper_at + 8 + displacement == helper_at,
        },
        'inter_contribution_padding': {
            'start': wrapper_end,
            'end_exclusive': helper_at,
            'length': max(0, helper_at - wrapper_end),
            'hex': image[wrapper_end:helper_at].hex() if helper_at >= wrapper_end else '',
        },
        'tail_at_003C_hex': region.hex(),
        'tail_at_003C_equals_original18': region == TAIL,
        'wrapper_bytes_hex': WRAPPER.hex(),
        'helper_bytes_hex': HELPER.hex(),
        'relocations': relocs,
        'entry_cs': header['cs'],
        'entry_ip': header['ip'],
        'overlay_bytes': len(overlay),
        'map_sha256': sha(map_text.encode('cp437', errors='replace')),
        'map_public_symbols': map_public_symbols(map_text),
        'map_segment_rows': map_segment_rows(map_text),
        'map_note': 'TLINK MAP reports the aggregate CODE start/stop/length and entry point; it omits these PUBLIC symbol rows. Offsets above are byte-derived from linked module output.',
        'map_text': map_text,
        'map_path': str((folder / 'OUT.MAP').relative_to(ROOT)).replace('\\', '/'),
    }


def run():
    pins = verify_pins()
    original, original_manifest = extract()
    target = original[0x1537C:0x1538E]
    if target != TAIL:
        raise AssertionError('Probe instructions differ from independently extracted original bytes')
    out_root = ROOT / 'build' / 'critical-vector-topology'
    out_root.mkdir(parents=True, exist_ok=True)
    results = {}
    for name, (alignment, split) in VARIANTS.items():
        results[name] = run_variant(name, alignment, split, out_root)

    # Record comparisons as observed, including any result contrary to expectation.
    byte_equivalent = results['combined_byte']['tail_at_003C_hex'] == results['split_byte']['tail_at_003C_hex']
    results['comparisons'] = {
        'combined_vs_split_byte_tail_equal': byte_equivalent,
        'combined_vs_split_byte_entire_module_equal':
            results['combined_byte']['module_hex'] == results['split_byte']['module_hex'],
        'split_word_tail_equal_original18': results['split_word']['tail_at_003C_equals_original18'],
        'split_para_tail_equal_original18': results['split_para']['tail_at_003C_equals_original18'],
    }
    report = {
        'schema': 1,
        'purpose': 'Bounded candidate-link probe of a synthetic 60-byte prefix plus the measured 1534:003C wrapper and 0045 helper bytes.',
        'scope': 'Four variants only: one combined BYTE object; split BYTE, WORD, and PARA helper contributions. No game execution.',
        'pins_verified': pins,
        'target': {
            'original_image_sha256': sha(original),
            'original_linear_range': [0x1537C,0x1538E],
            'synthetic_prefix_bytes': PREFIX_BYTES,
            'wrapper_original_offset': 0x003C,
            'helper_original_offset': 0x0045,
            'wrapper_bytes': WRAPPER.hex(),
            'helper_bytes': HELPER.hex(),
            'combined_target_sha256': sha(target),
        },
        'results': results,
        'interpretation': {
            'confidence': 'PROBE_ONLY',
            'claim': 'The variants constrain candidate TASM/TLINK placement behavior for these bytes; they do not establish Overkill historical objects or linker settings.',
        },
    }
    write_json(ROOT / 'metadata' / 'critical-vector-topology.json', report)
    print(json.dumps({'comparisons': report['results']['comparisons'],
                      'variants': {k: {key: v[key] for key in ('wrapper_offset_by_bytes', 'helper_offset_by_bytes',
                                                               'tail_at_003C_hex', 'relocations', 'map_public_symbols')}
                                   for k, v in results.items() if k != 'comparisons'}}, indent=2))
    return report


if __name__ == '__main__':
    run()
