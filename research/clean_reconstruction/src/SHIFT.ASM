; Link-order witness, unreachable data in the code segment, not original bytes.
.8086
_TEXT segment byte public 'CODE'
    db 37 dup (0)
_TEXT ends
end
