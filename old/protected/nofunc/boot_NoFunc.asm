;Bootloader, bootsect.asm
org	0x7C00

;Video memory
mov	ax, 0xB800
mov	es, ax

mov	ax, [Background]
mov	bx, 0
mov	cx, 80*25*2

CLS:
	mov	[es:bx], ax
	add	bx, 1
	loop	CLS

READ:
	mov	al, 0x10
	mov 	[0x500], al

	mov	ax, 0x1
	mov	[0x502], ax

	mov	eax, 0x8000	; 
	mov	[0x504], eax

	mov	eax, 1		;LBA number
	mov 	[0x508], eax

	mov	ax, 0x500
	mov	si, ax
	mov	ax, 0
	mov	ds, ax
	mov	ah, 0x42
	mov	dl, 0x80

	int	0x13
	jc	READ

jmp	0x8000

Background	db 0x00

times 510-($-$$) db 0x00


dw 0xaa55
