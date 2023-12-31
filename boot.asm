ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0

start:
    jmp 0:step2

step2:
    cli ; clear interrupts
    
    mov ax, 0x00
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7c00

    sti ; enable interrupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; Global Descriptor Table
gdt_start:

gdt_null:
    dd 0x0
    dd 0x0

; offset 0x8
gdt_code:       ; Code Segment should point to this
    dw 0xffff   ; segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x9a     ; Access byte (bitmask)
    db 11001111b    ; High 4bit flags and low 4bit flags
    db 0        ; Base 24-31 bits

; offset 0x10
gdt_data:       ; DS, SS, ES, FS, GS
    dw 0xffff   ; segment limit first 0-15 bits
    dw 0        ; Base first 0-15 bits
    db 0        ; Base 16-23 bits
    db 0x92     ; Access byte (bitmask)
    db 11001111b    ; High 4bit flags and low 4bit flags
    db 0        ; Base 24-31 bits

gdt_end:
    
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; size
    dd gdt_start                ; offset

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    
    jmp $

; Putting boot signature 0x55AA on last 2 bytes
times 510-($ - $$) db 0 ; We have to fill at least 510 B of data. If less is filled, other gets padded.
dw 0xAA55               ; Write 55AA (Little endian)