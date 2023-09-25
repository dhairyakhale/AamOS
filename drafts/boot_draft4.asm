ORG 0
BITS 16

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0x7c0:step2

; Create interrupts (rewording what the existing IVT interrupt would do)
handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

handle_one:
    mov ah, 0eh
    mov al, 'V'
    mov bx, 0x00
    int 0x10
    iret

step2:
    cli ; clear interrupts
    
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax

    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    sti ; enable interrupts

    ; set very first byte of ram as interrupt vector table
    ; by default it would've used ds, which points at 0x7c0

    mov word[ss:0x00], handle_zero  ; maps to IVT 0 (divide by zero)
    mov word[ss:0x02], 0x7c0

    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    ; dividing by zero
    mov ax, 0x00
    div ax

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