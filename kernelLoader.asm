; kernel.asm

[bits	16]
org	0x8000
jmp	Entry16
%include "func_16.asm"

Entry16:

	; Load Kernel

    ;Call ClearBackground
    mov ax, 0
    mov ds, ax
    mov si, bootingMsg
    Call PrintString

	; TODO: change parameter according to the actual file size
	mov	ax, 1; Kernel size
	mov	ebx, 0x40000000 ; Kernel address
	mov	ecx, 2 ; Kernel start LBA
	call	ReadSectors

	xor	ax, ax
	lgdt	[gdtr]	; Load gdt
	cli         ; Disable interrupt

	; Turn on 32-bit protected mode
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax

	jmp	$+2
	nop
	nop

	jmp	codeDescriptor:Entry32

;************************
;	32-bit
;************************

[bits	32]
Entry32:
	; initial segment register
	mov	bx, dataDescriptor
	mov	ds, bx
	mov	es, bx
	mov	fs, bx
	mov	gs, bx
	mov	ss, bx
	xor	esp, esp
	mov	esp, 0x9FFFF

	jmp codeDescriptor:0x40000
	

;************************
;	GDT
;************************

gdtr:
	dw gdt_end - gdt - 1
	dd gdt

gdt:
;NULL descripter
nullDestriptor  equ 0x00
        dw 0
        dw 0
        db 0
        db 0
        db 0
        db 0
codeDescriptor  equ 0x08
    dw 0xFFFF               ; limit:0xFFFF
    dw 0x0000               ; base 0~15 : 0
    db 0x00                 ; base 16~23: 0
    db 0x9A                 ; P:1, DPL:0, Code, non-conforming, readable
    db 0xCF                 ; G:1, D:1, limit:0xF
    db 0x00                 ; base 24~32: 0
dataDescriptor  equ 0x10
    dw 0xFFFF               ; limit 0xFFFF
    dw 0x0000               ; base 0~15 : 0
    db 0x00                 ; base 16~23: 0
    db 0x92                 ; P:1, DPL:0, data, readable, writable
    db 0xCF                 ; G:1, D:1, limit:0xF
    db 0x00                 ; base 24~32: 0
videoDescriptor equ 0x18
    dw 0xFFFF               ; limit 0xFFFF
    dw 0x8000               ; base 0~15 : 0x8000
    db 0x0B                 ; base 16~23: 0x0B
    db 0x92                 ; P:1, DPL:0, data, readable, writable
    db 0xCF                 ; G:1, D:1, limit:0xF
    db 0x00                 ; base 24~32: 0

gdt_end:

bootingMsg db "Now Booting..", 0

;gdt_codeSeg equ (codeDescripter - gdt)
;gdt_dataSeg equ dataDescripter - gdt
;gdt_videoSeg equ videoDescripter - gdt

times 512-($-$$) db 0x00
