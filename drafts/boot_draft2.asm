ORG 0
BITS 16

jmp 0x7c0:start ; makes our code segment 0x7c0

start:
    cli ; clear interrupts
    
    ; Setting segment regs according to us
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax

    ; Setting stack separately (as it grows downwards)
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    sti ; enable interrupts
    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message:
    db 'Hello World!', 0

; Putting boot signature 0x55AA on last 2 bytes
times 510-($ - $$) db 0 ; We have to fill at least 510 B of data. If less is filled, other gets padded.
dw 0xAA55               ; Write 55AA (Little endian)