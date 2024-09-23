.module asm2err

cpc_run_address::
	; We start with a one-time configuration option.

	; If you're tight on memory, you might want to remove this jump and the part that sets it (look for jr_configure).

	; This will save a few bytes and cause configuration to be run
	; each time, but hey, this is in a BASIC context, so we have
	; plenty of cycles.
	; ----------------------------------------------------------------
jr_configure:
	jr configure		; Once configured, jump destination adjusted to not configure again.
	; ----------------------------------------------------------------
configure:
	push de			; Save error number.

	; ld a, #82 ; 'R'
	; call 0xBB5A

	; Fetch byte at ROM 0xC002 of upper ROM, which is rom version number.
	call 0xB900 		; KL U ROM ENABLE
	ld hl, #0xC002
	ld c,(hl)
	; call 0xB90C		; KL ROM RESTORE ; can be skipped since firmware will take control anyway
	; Ok ROM version number is in C.

; 	; The part below sanity checks the ROM number and displays something if unsupported.
; 	; You might want to cut it away to save a few bytes.
; 	; -------------------------------- sanity checks BEGIN
; 	; Sanity check value.
; 	ld a, c
; 	cp #5 ; max supported ROM configuration
; 	jr c, supported
; 	; unexpected ROM number, shout it to the screen repeatedly
; crash:
; 	push af
; 	call #0xBB5D
; 	pop af
; 	jr crash
; supported:
; 	; -------------------------------- sanity check END

	; Compute address from where to pick value.
	ld b, #0
	ld hl, #table
	add hl, bc
	add hl, bc		; HL points to correct entry in table.

	ld de, # where_hl_is_set+1

	ldi			; Copy one byte.
	ldi			; Copy second byte.

	; If you're tight on memory, you might want to remove the part below and matching jr above (look for jr_configure).
	; ----------------------------------------------------------------
	ld hl, # jr_configure+1
	ld (hl), # raise_error - jr_configure - 2
	; ----------------------------------------------------------------

	; Configuration done!
	pop de			; Restore error number.

	; ----------------------------------------------------------------
	; Actual work
	; ----------------------------------------------------------------
raise_error:
	; Preparing for "jp 0x1B" which assumes:
	; - HL is set to an address (done above),
	; - C specifies whether to enable upper or lower ROM
where_hl_is_set:
	ld hl, # 0x0000		; Placeholder value, will be set by configuration on first run.
	ld c, #0xFD 		; Enable upper rom only.

	ld a, e			; Get error number from CALL argument.
	jp 0x1B	    		; Jump to address at HL, with ROM enable status as specified by C.

table:
.dw 0xCA93			; Location on a CPC464, visible in e.g. "CPC 464 Intern" from Data Becker, page 366.
.dw 0xCB58			; Location on a CPC664, obtained by looking in CPCEC's debugger.
.dw 0xCB55			; Location on a CPC6128, see e.g. https://github.com/Bread80/Amstrad-CPC-BASIC-Source/blob/main/BASIC1.1.disasm#L2512
.dw 0xCB55			; Does Basic ROM version 3 even exist?
.dw 0xCB55			; Location on a CPC+, obtained by disassembling the ROM with z80dasm.

.area _DATA			; To make linker happy
