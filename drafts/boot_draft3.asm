; setting up code to boot on real machine

ORG 0
BITS 16

; Jump over disk format information, without this processor attempts to execute data that isn't code
; Refer https://wiki.osdev.org/FAT#BPB_.28BIOS_Parameter_Block.29
_start:
    jmp short start
    nop

times 33 db 0   ; create 33 bytes (bytes parameter block)

start:
    jmp 0x7c0:step2

step2:
    cli ; clear interrupts
    
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax

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