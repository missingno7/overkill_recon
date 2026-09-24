; Modern encoding controls, not claimed historical macros.
.8086
CALL_NEAR macro target
 db 0E8h
 dw (target-($-chunk_base)-2) AND 0ffffh
endm
JMP_NEAR macro target
 db 0E9h
 dw (target-($-chunk_base)-2) AND 0ffffh
endm
JMP_SHORT macro target
 db 0EBh
 db (target-($-chunk_base)-1) AND 0ffh
endm
JO_SHORT macro target
 db 070h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JNO_SHORT macro target
 db 071h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JB_SHORT macro target
 db 072h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JAE_SHORT macro target
 db 073h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JE_SHORT macro target
 db 074h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JNE_SHORT macro target
 db 075h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JBE_SHORT macro target
 db 076h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JA_SHORT macro target
 db 077h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JS_SHORT macro target
 db 078h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JNS_SHORT macro target
 db 079h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JP_SHORT macro target
 db 07Ah
 db (target-($-chunk_base)-1) AND 0ffh
endm
JNP_SHORT macro target
 db 07Bh
 db (target-($-chunk_base)-1) AND 0ffh
endm
JL_SHORT macro target
 db 07Ch
 db (target-($-chunk_base)-1) AND 0ffh
endm
JGE_SHORT macro target
 db 07Dh
 db (target-($-chunk_base)-1) AND 0ffh
endm
JLE_SHORT macro target
 db 07Eh
 db (target-($-chunk_base)-1) AND 0ffh
endm
JG_SHORT macro target
 db 07Fh
 db (target-($-chunk_base)-1) AND 0ffh
endm
LOOPNE_SHORT macro target
 db 0E0h
 db (target-($-chunk_base)-1) AND 0ffh
endm
LOOPE_SHORT macro target
 db 0E1h
 db (target-($-chunk_base)-1) AND 0ffh
endm
LOOP_SHORT macro target
 db 0E2h
 db (target-($-chunk_base)-1) AND 0ffh
endm
JCXZ_SHORT macro target
 db 0E3h
 db (target-($-chunk_base)-1) AND 0ffh
endm
CALL_FAR macro segval,offval
 db 09Ah
 dw offval,segval
endm
JMP_FAR macro segval,offval
 db 0EAh
 dw offval,segval
endm
