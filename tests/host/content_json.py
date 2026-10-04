"""Standalone regressions for the strict runtime JSON reader.

This compiles only host/content_json.c into a private probe library. It does not
build the SDL core or load game/oracle state.
"""
from pathlib import Path
import ctypes
import os
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / 'build' / 'host'


class Token(ctypes.Structure):
    _fields_ = [
        ('type', ctypes.c_int),
        ('start', ctypes.c_size_t),
        ('end', ctypes.c_size_t),
        ('first_child', ctypes.c_size_t),
        ('last_child', ctypes.c_size_t),
        ('next_sibling', ctypes.c_size_t),
        ('child_count', ctypes.c_size_t),
        ('string_length', ctypes.c_size_t),
        ('string_value', ctypes.c_void_p),
    ]


class Document(ctypes.Structure):
    _fields_ = [('text', ctypes.c_void_p),
                ('tokens', ctypes.POINTER(Token)),
                ('count', ctypes.c_size_t)]


def build_probe() -> Path:
    OUT.mkdir(parents=True, exist_ok=True)
    library = OUT / ('content_json_probe.dll' if os.name == 'nt'
                     else 'content_json_probe.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra',
               '-Werror', '-shared', '-I' + str(ROOT / 'host'),
               str(ROOT / 'host' / 'content_json.c')]
    command += ['-static-libgcc'] if os.name == 'nt' else ['-fPIC']
    subprocess.run(command + ['-o', str(library)], cwd=ROOT, check=True)
    return library


def api():
    lib = ctypes.CDLL(str(build_probe()))
    lib.content_json_load.argtypes = [ctypes.c_char_p, ctypes.POINTER(Document),
                                      ctypes.c_char_p, ctypes.c_size_t]
    lib.content_json_load.restype = ctypes.c_int
    lib.content_json_free.argtypes = [ctypes.POINTER(Document)]
    lib.content_json_free.restype = None
    lib.content_json_member.argtypes = [ctypes.POINTER(Document), ctypes.c_int,
                                        ctypes.c_char_p]
    lib.content_json_member.restype = ctypes.c_int
    lib.content_json_size.argtypes = [ctypes.POINTER(Document), ctypes.c_int]
    lib.content_json_size.restype = ctypes.c_size_t
    lib.content_json_at.argtypes = [ctypes.POINTER(Document), ctypes.c_int,
                                    ctypes.c_size_t]
    lib.content_json_at.restype = ctypes.c_int
    lib.content_json_integer.argtypes = [ctypes.POINTER(Document), ctypes.c_int,
                                         ctypes.POINTER(ctypes.c_long)]
    lib.content_json_integer.restype = ctypes.c_int
    lib.content_json_string.argtypes = [ctypes.POINTER(Document), ctypes.c_int,
                                        ctypes.c_char_p, ctypes.c_size_t]
    lib.content_json_string.restype = ctypes.c_int
    lib.content_json_equal.argtypes = [ctypes.POINTER(Document), ctypes.c_int,
                                       ctypes.POINTER(Document), ctypes.c_int]
    lib.content_json_equal.restype = ctypes.c_int
    return lib


class JsonProbe:
    def __init__(self, lib, source: bytes):
        self.lib = lib
        self.document = Document()
        self._file = tempfile.NamedTemporaryFile(delete=False, suffix='.json')
        self.path = self._file.name
        try:
            self._file.write(source)
            self._file.close()
        except BaseException:
            self._file.close()
            Path(self.path).unlink(missing_ok=True)
            raise
        self.error = ctypes.create_string_buffer(512)
        self.loaded = bool(lib.content_json_load(os.fsencode(self.path),
                                                 ctypes.byref(self.document),
                                                 self.error, len(self.error)))

    def close(self):
        self.lib.content_json_free(ctypes.byref(self.document))
        Path(self.path).unlink(missing_ok=True)

    def __enter__(self):
        return self

    def __exit__(self, *_):
        self.close()

    def require_load(self):
        if not self.loaded:
            raise AssertionError('valid JSON rejected: ' + self.error.value.decode('utf-8', 'replace'))

    def require_reject(self):
        if self.loaded:
            raise AssertionError('invalid JSON was accepted')
        if self.document.count or self.document.tokens or self.document.text:
            raise AssertionError('failed load did not leave the document empty')


def parse(lib, source: bytes) -> JsonProbe:
    result = JsonProbe(lib, source)
    result.require_load()
    return result


def reject(lib, source: bytes):
    with JsonProbe(lib, source) as result:
        result.require_reject()


def checks(lib):
    # Numeric grammar is strict, while valid fractions and exponents remain valid JSON.
    for source in (b'01', b'-01', b'+1', b'-', b'.1', b'1.', b'1e', b'1e+', b'NaN', b'Infinity'):
        reject(lib, source)
    for source in (b'0', b'-0', b'1.25', b'1e-3'):
        with parse(lib, source):
            pass

    reject(lib, b'{"same":1,"same":2}')
    reject(lib, b'{"x\\u0000suffix":1,"x\\u0000suffix":2}')

    # Decoded equality handles both escaped Unicode and NUL-containing keys;
    # object order is irrelevant but array order and value types are significant.
    with parse(lib, b'{"name":"\\u00e9","arr":[1,true]}') as a, \
         parse(lib, '{"arr":[1,true],"name":"é"}'.encode('utf-8')) as b, \
         parse(lib, b'{"arr":[true,1],"name":"\\u00e9"}') as c, \
         parse(lib, b'{"arr":[1,1],"name":"\\u00e9"}') as d:
        assert lib.content_json_equal(ctypes.byref(a.document), 0,
                                      ctypes.byref(b.document), 0)
        assert not lib.content_json_equal(ctypes.byref(a.document), 0,
                                          ctypes.byref(c.document), 0)
        assert not lib.content_json_equal(ctypes.byref(a.document), 0,
                                          ctypes.byref(d.document), 0)
    with parse(lib, b'"\\ud83d\\ude80"') as escaped, \
         parse(lib, '"🚀"'.encode('utf-8')) as literal:
        assert lib.content_json_equal(ctypes.byref(escaped.document), 0,
                                      ctypes.byref(literal.document), 0)
    reject(lib, b'"\\ud83d"')

    nul_key_a = parse(lib, b'{"x\\u0000suffix":1}')
    nul_key_b = parse(lib, b'{"x":1}')
    nul_key_same = parse(lib, b'{"x\\u0000suffix":1}')
    try:
        assert not lib.content_json_equal(ctypes.byref(nul_key_a.document), 0,
                                          ctypes.byref(nul_key_b.document), 0)
        assert not lib.content_json_equal(ctypes.byref(nul_key_b.document), 0,
                                          ctypes.byref(nul_key_a.document), 0)
        assert lib.content_json_equal(ctypes.byref(nul_key_a.document), 0,
                                      ctypes.byref(nul_key_same.document), 0)
    finally:
        nul_key_a.close()
        nul_key_b.close()
        nul_key_same.close()

    with parse(lib, b'{"text":"\\u0000suffix","value":7}') as document:
        text_index = lib.content_json_member(ctypes.byref(document.document), 0, b'text')
        value_index = lib.content_json_member(ctypes.byref(document.document), 0, b'value')
        assert text_index >= 0 and value_index >= 0
        output = ctypes.create_string_buffer(64)
        assert not lib.content_json_string(ctypes.byref(document.document), text_index,
                                           output, len(output))
        value = ctypes.c_long()
        assert lib.content_json_integer(ctypes.byref(document.document), value_index,
                                        ctypes.byref(value)) and value.value == 7

    long_bits = ctypes.sizeof(ctypes.c_long) * 8
    long_max = (1 << (long_bits - 1)) - 1
    long_min = -(1 << (long_bits - 1))
    for number, expected, accepted in ((str(long_max), long_max, True),
                                      (str(long_min), long_min, True),
                                      (str(long_max + 1), 0, False),
                                      (str(long_min - 1), 0, False),
                                      ('1.0', 0, False), ('1e0', 0, False)):
        with parse(lib, number.encode('ascii')) as document:
            result = ctypes.c_long()
            converted = bool(lib.content_json_integer(ctypes.byref(document.document), 0,
                                                        ctypes.byref(result)))
            assert converted == accepted
            if accepted:
                assert result.value == expected

    # Exactly 64 nested containers pass; the 65th is rejected.
    with parse(lib, b'[' * 64 + b'0' + b']' * 64):
        pass
    reject(lib, b'[' * 65 + b'0' + b']' * 65)

    # The token ceiling includes the root array; keep each fixture under the byte cap.
    with parse(lib, b'[' + b'0,' * 65534 + b'0]'):
        pass
    reject(lib, b'[' + b'0,' * 65535 + b'0]')
    reject(lib, b' ' * (1024 * 1024 + 1))


def main():
    checks(api())
    print('PASS strict runtime JSON parser: grammar, bounds, unicode, NUL-safe equality and accessors')


if __name__ == '__main__':
    main()
