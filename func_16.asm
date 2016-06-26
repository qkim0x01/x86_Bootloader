
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
    


