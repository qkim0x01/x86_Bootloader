
org 0x7C00

mov	ax, 0xB800
mov	es, ax
mov	ax, 0
mov	di, ax
mov	cx, 80*20*2
rep stosd

mov	ax,0
mov	ds, ax
mov	si, message#1
call	PrintString

jmp $


message#1	db "Now Booting...", 0



;****************************************
;	PrintString
;	@param: ds:si - String addr
;			si - String offset
;*****************************************
PrintString:
	pusha
	mov	ax, 0xB800
	mov	es, ax
	mov	ah, 0x09
	mov	di, 0	; Video offset

	.loop:
		mov	al, [ds:si]
		cmp	al, 0
		je	.endFunc

		mov	[es:di], ax
		add	si, 1
		add	di, 2
		jmp	.loop

	.endFunc:
		popa
		ret

	
times 510-($-$$) db 0
dw 0xaa55
