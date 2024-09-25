.module asm2err

cpc_run_address::
	; Error number comes in through DE.

	; Fetch byte at ROM 0xC002 of upper ROM, which is rom version number.
	call 0xB900 		; KL U ROM ENABLE
	ld hl, #0xC002
	ld b,(hl)

	; Firmware preserves E on call to 0xB900.

	; Error number comes in through DE, set A to it.
	ld a,e			; A = error number

	inc b
	djnz not_rom0_cpc464
	jp 0xca93		; Location on a CPC464, visible in e.g. "CPC 464 Intern" from Data Becker, page 366.
not_rom0_cpc464:
	djnz not_rom1_cpc664
	jp 0xcb58		; Location on a CPC664, obtained by looking in CPCEC's debugger.
not_rom1_cpc664:
	; assume all ROMs are like BASIC 1.1. This is true for CPC+ models.
	jp 0xcb55		; Location on a CPC6128, see e.g. https://github.com/Bread80/Amstrad-CPC-BASIC-Source/blob/main/BASIC1.1.disasm#L2512

.area _DATA			; To make linker happy
