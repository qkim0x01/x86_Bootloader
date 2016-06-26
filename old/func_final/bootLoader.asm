;Bootloader, bootsect.asm
org	0x7C00

call ClearBackground
rep stosd

mov	ax, 0x1
mov	ebx, 0x8000
mov	ecx, 0x1
call ReadSectors

jmp	0x8000

;**********************************
;	Varialbes
;**********************************
Background	db 0x00


;**********************************
;	ClearBackground
;**********************************
ClearBackground:
	pusha
	mov	ax, 0xB800
	mov	es, ax

	mov	ax, [Background]
	mov	bx, 0
	mov	cx, 80*25*2

	CLS:
		mov	[es:bx], ax
		add	bx, 1
		loop	CLS
	popa
	ret
	

;***************************************
;	ReadSectors
;	param	@ax - Number of sectors
;		@ebx - Transfer Buffer
;		@ecx - Starting LBA
;***************************************

ReadSectors:

	pusha
	.retry:
		push	ax

		mov 	dl, 0x10
		mov	[0x500], dl
		mov	dl, 0x00
		mov	[0x501], dl
		mov	[0x502], ax
		mov	[0x504], ebx
		mov	[0x508], ecx

		mov	ax, 0x500
		mov	si, ax
		mov	ax, 0
		mov	ds, ax

		mov	ah, 0x42
		mov	dl, 0x80
		int	0x13

		pop	ax
		jc	.retry
	popa
	ret


times 510-($-$$) db 0x00
dw 0xaa55
