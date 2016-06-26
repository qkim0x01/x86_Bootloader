;Bootloader, bootsect.asm
[bits	16]
org	0x7C00
jmp Entry
%include "func_16.asm"

Entry:

;call ClearBackground

;rep stosd

mov	ax, 0x1
mov	ebx, 0x8000
mov	ecx, 0x1    ; kernelLoader start LBA
call ReadSectors

jmp	0x8000

;**********************************
;	Varialbes
;**********************************



times 510-($-$$) db 0x00
dw 0xaa55
