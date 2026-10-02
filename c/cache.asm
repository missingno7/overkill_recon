; Cache/resource entry bridges and DOS/EMS services.
include SYSTEM.INC
locals
extrn COPY_FROM_FILE_CACHE:near
extrn CACHE_LOADED_FILE:near
extrn RELEASE_EMS_CACHE:near
extrn LOAD_RESOURCE_FILE:near
extrn FarCallMainNearViaAX:far
extrn FileBufferSegment:word

MAIN segment byte public 'CODE'
assume cs:MAIN, ds:nothing, ss:nothing, es:nothing
public CopyFromFileCache, CacheLoadedFile, ReleaseEmsCache, LoadResourceFile

CopyFromFileCache:
    call COPY_FROM_FILE_CACHE
    or al, al
    jnz @@copyMiss
    mov es, word ptr ds:[FileBufferSegment]
@@copyMiss:
    ret

CacheLoadedFile:
    mov si, es
    call CACHE_LOADED_FILE
    mov es, ax
    ret

ReleaseEmsCache:
    call RELEASE_EMS_CACHE
    ret

; C receives a pointer to this live BP/ES pair and returns its actual output ES.
LoadResourceFile:
    push es
    push bp
    mov bp, sp
    mov si, bp
    call LOAD_RESOURCE_FILE
    mov es, word ptr ss:[bp + 2]
    mov bp, word ptr ss:[bp]
    add sp, 4
    ret
MAIN ends

CGAME segment byte public 'CODE'
assume cs:CGAME
public CACHE_CALL_MAIN, CACHE_PROBE, CACHE_MAP_EMS
public CACHE_GET_DRIVE, CACHE_CLOSE_FILE, CACHE_ALLOCATE_DOS
public CACHE_ALLOCATE_EMS, CACHE_FREE_EMS

; Preserve Watcom's frame pointer while the legacy routine receives its own BP use.
CACHE_CALL_MAIN:
    push bp
    call far ptr FarCallMainNearViaAX
    pop bp
    retf

; AX = MAIN near target. Return AX=1 for ZF, AX=0 for NZ from the platform leaf.
CACHE_PROBE:
    push bp
    call far ptr FarCallMainNearViaAX
    mov ax, 0
    jnz @@notReady
    inc ax
@@notReady:
    pop bp
    retf

; AX = MAIN near target, BX = EMS page count, DX = handle.
CACHE_MAP_EMS:
    push bp
    call far ptr FarCallMainNearViaAX
    pop bp
    retf

CACHE_GET_DRIVE:
    push bp
    mov ah, DOS_GET_DRIVE
    int 021h
    pop bp
    retf

; BX = handle; the original ignores close errors.
CACHE_CLOSE_FILE:
    push bp
    mov ah, DOS_CLOSE_FILE
    int 021h
    pop bp
    retf

; BX = requested DOS paragraphs; return DX=CF, AX=segment or error.
CACHE_ALLOCATE_DOS:
    push bp
    mov ah, DOS_ALLOCATE_MEMORY
    int 021h
    pushf
    pop dx
    and dx, 1
    pop bp
    retf

; BX = EMS pages; return DX=EMS status, AX=allocated handle.
CACHE_ALLOCATE_EMS:
    push bp
    mov ah, 043h
    int 067h
    mov cl, ah
    xor ch, ch
    mov ax, dx
    mov dx, cx
    pop bp
    retf

; DX = EMS handle; the original ignores free errors.
CACHE_FREE_EMS:
    push bp
    mov ah, 045h
    int 067h
    pop bp
    retf
CGAME ends
end
