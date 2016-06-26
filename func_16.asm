;Functions for 16-bit Real Mode
; ReadSectors
; Test_a20
; ClearBackground
; PrintString

;***************************************
;ReadSectors
;   BIOS Interrupt Call
;   INT 13h AH=42h; Extended Read Sectors From Drive
;       param   @ax - Number of sectors
;               @ebx - Transfer Buffer [seg:offset]
;               @ecx - Starting LBA
;
;       return  @CF - Set on error
;               @AH - Return Cocde
;***************************************

ReadSectors:

        pusha
        .retry:
                push    ax

                mov     dl, 0x10
                mov     [0x500], dl ; DAP size
                mov     dl, 0x00
                mov     [0x501], dl
                mov     [0x502], ax
                mov     [0x504], ebx
                mov     [0x508], ecx

                mov     ax, 0x500   ; DAP start addr
                mov     si, ax
                mov     ax, 0
                mov     ds, ax      ; Read from ds:si

                mov     ah, 0x42    ; Read sectors from drive (int 13)
                mov     dl, 0x80    ; For "C" drive
                int     0x13

                pop     ax
                jc      .retry
        popa
        ret


;**********************************
;	Test_A20
;		return	@ax	:0 - A20 disabled
;					:1 - A20 enabled
;**********************************
Test_A20:

	pushf
	push	ds
	push	es
	push	di
	push	si

	cli

	xor		ax, ax
	mov		es, ax
	not		ax
	mov		ds, ax
	mov 	di, 0x500
	mov 	si, 0x510
	mov 	al, byte [es:di]	; 0000:500
	push 	ax
	mov 	al, byte [ds:si] 	; FFFF:510
	push 	ax

	mov 	byte [es:di], 0x00
	mov 	byte [ds:si], 0xFF

	cmp 	byte [es:di], 0xFF	; Compare value

	pop 	ax
	mov 	byte [ds:si], al
	pop 	ax
	mov 	byte [es:di], al

	mov		ax, 0
	je 		check_a20_exit

	mov 	ax,1


	check_a20_exit:
		pop 	si
		pop 	di
		pop 	es
		pop 	ds
		popf

	sti			;TODO: Check if it's needed
	ret
	

;**********************************
;	EnableA20_BIOS
;**********************************
EnableA20_BIOS:
	mov		ax, 0x2401
	int		0x15
	ret


;**********************************
;	EnableA20_SysCtrl
;		Might not work for some system
;**********************************
EnableA20_SysCtrl:
	in		al, 0x92
	test	al, 2
	jnz		.Already_On
	or		al, 2
	and		al, 0xFE	; Make sure 0 bit (fast rest) == 0
	out		0x92, al

	.Already_On:
	ret


;**********************************
;	EnableA20_Keyboard
;**********************************
EnableA20_Keyboard:
	cli
	pusha

		; Disable Keyboard
		call 	.WaitInput
		mov		al, 0xAD
		out		0x64, al

		; Read output port
		call	.WaitInput
		mov		al, 0xD0
		out		0x64, al

		; Read Input Buffer
		call	.WaitOutput
		in		al, 0x60
		push	eax

		; Write Output Port
		call	.WaitInput
		mov		al, 0xD1
		out		0x64, al

		; Send new status value
		call	.WaitInput
		pop		eax
		or		al, 2
		out		0x60, al

		; Enable Keyboard
		call	.WaitInput
		mov		al, 0xAE
		out		0x64, al

		call	.WaitInput

	popa
	sti
	ret

	.WaitOutput:
		in		al, 0x64
		test	al, 1
		jz		.WaitOutput
		ret

	.WaitInput:
		in		al, 0x64
		test	al, 2
		jnz		.WaitInput
		ret


;**********************************
;	ClearBackground
;**********************************
ClearBackground:
        pusha
        mov     ax, 0xB800
        mov     es, ax

        mov     ax, [Background]
        mov     bx, 0
        mov     cx, 80*25*2

        CLS:
                mov     [es:bx], ax
                add     bx, 1
                loop    CLS
        popa
        ret

Background	db 0x0

;**********************************
;	Print String
;       param @ ds:si - string address
;**********************************
PrintString:
        pusha
        mov     ax, 0xB800
        mov     es, ax
        mov     ah, 0x07
        mov     di, 0
        xor     bx, bx

        .loop:
                mov     al, [ds:si]
                cmp     al, 0
                je      .endFunc

                add     bx, 1
                cmp     bx, maxLen
                je      .endFunc    ; TODO: print error message

                mov     [es:di], ax
                add     si, 1
                add     di, 2
                jmp     .loop
        .endFunc:
            popa
            ret

        ;maxLen  equ 80*25*2
        maxLen  db 10
    


