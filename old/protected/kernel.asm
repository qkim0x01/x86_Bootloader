; kernel.asm

org	0x8000


;Register GDT

xor	ax, ax
lgdt	[gdtr]
cli

; Turn on 32-bit protected mode
mov	eax, cr0
or	eax, 1
mov	cr0, eax

jmp	$+2
nop
nop

jmp	codeDescripter:Entry32

;************************
;	32-bit
;************************

[bits	32]
Entry32:
	; initial segment register
	mov	bx, dataDescripter
	mov	ds, bx
	mov	es, bx
	mov	fs, bx
	mov	gs, bx
	mov	ss, bx
	xor	esp, esp
	mov	esp, 0x9FFFF

	; es <- videoDescripter
	mov	ax, 0x18
	mov	es, ax
	
	; print
	mov	ah, 0x09
	mov	al, 'H'
	mov	[es:0x0000], ax
	mov	al, 'i'
	mov	[es:0x0002], ax
	mov	al, 'i'
	mov	[es:0x0004], ax

	jmp $


;************************
;	GDT
;************************

gdtr:
	dw gdt_end - gdt - 1
	dd gdt

gdt:
;NULL descripter
nullDestripter  equ 0x00
        dw 0
        dw 0
        db 0
        db 0
        db 0
        db 0
;code descripter
codeDescripter  equ 0x08
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 0x9A
        db 0xCF
        db 0x00
dataDescripter  equ 0x10
        dw 0xFFFF
        dw 0x0000
        db 0x00
        db 0x92 ;10010010b
        db 0xCF ;11001111b
        db 0x00
vedioDescripter equ 0x18
        dw 0xFFFF
        dw 0x8000
        db 0x0B
        db 0x92
        db 0xCF
        db 0x00

gdt_end:

;gdt_codeSeg equ (codeDescripter - gdt)
;gdt_dataSeg equ dataDescripter - gdt
;gdt_videoSeg equ videoDescripter - gdt

times 512-($-$$) db 0x00
