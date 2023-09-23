ORG 0x7c00  ; Find program in this location
BITS 16     ; 16 bit program

start:
    ; Below is a BIOS routine to print letter A and advance cursor
    ; Reference: ralph brown interrupt list
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0
    int 0x10

    jmp $   ; Self loop to keep it running

; Putting boot signature 0x55AA on last 2 bytes
times 510-($ - $$) db 0 ; We have to fill at least 510 B of data. If less is filled, other gets padded.
dw 0xAA55               ; Write 55AA (Little endian)