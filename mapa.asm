;=====================================================================
; Wiktor Sleczka
;
; Project x86 2.6
; Height map generator.
;=====================================================================

section	.text
global  mapa

mapa:
	; prologue
	push	ebp				; Store old EBP.
	mov	ebp,		esp		; Set new EBP.
	sub	esp,		12		; Five integer local variables.

	; body
	; Initization of data
	mov	ebx,		dword [ebp+16]	; Load address of struct informations.
	mov	eax,		dword [ebx]	; Load minimal value.
	mov	dword [ebp-4],	eax		; Store minimal value.
	mov	eax,		dword [ebx+4]	; Load maximal value.
	mov	dword [ebp-8],	eax		; Store maximal value.
	sub	eax,		dword [ebp-4]	; Count difference between max and min.
	mov	dword [ebp-12],	eax		; Store difference.

	; Prepare for loop
	mov	ecx,		201*201		; Load loop counter
	mov	esi,		dword [ebp+8]	; Load source address.
	mov	edi,		dword [ebp+12]	; Load destination address.
	mov	ebx,		0		; Zero row counter.
	cld					; Clear destination flag.
	jmp	loop1				; jump to the loop.

put_black:
	mov	eax,		0		; Store 0s
	jmp	loop1_continue			; Continue the loop.

put_white:
	mov	eax,		-1		; Store 1s
	jmp	loop1_continue			; Continue loop.

put_byte:
	mov	ebx,		0		; Prepare byte to store
	mov	byte [edi],	0x13		; Store new byte.
	inc	edi				; Correct address
loop1:
	lodsd					; Load first number into accumulator.
	cmp	eax,		dword [ebp-8]	; Compare value with maximal
	jge	put_black			; if higher than maximal, simply put black.
	sub	eax,		dword [ebp-4]	; Substract minimal value from current.
	js	put_white			; If result negative, simply put white.

	; Calculate correct value if not special case.
	mov	eax,		ebx		; Multiply value by 255 by
	shl	eax,		8		; multiplying it by 256
	sub	eax,		ebx		; and substracting original value once.
	div	dword [ebp-12]			; Normalization of value to 255.

loop1_continue:
	mov	byte [edi],	al		; Save result
	mov	byte [edi+1],	al		; three times,
	mov	byte [edi+2],	al		; once for each color.
	add	edi,		3		; and increment target counter.
	cmp	ebx,		200		; Check if empty byte should be given.
	je	put_byte			; Put one byte at the end of row.
	inc	ebx				; Increment row counter.
	loop	loop1				; Decrement loop counter and jump loop1 if nonzero.
	jmp	epilogue

; Swap rows.
	mov	esi,		dword [ebp+12]	; Load beginning of the file
	mov	edi,		esi		; Copy it to the second register
	; TODO replace with lea
	add	edi,		201*200*3	; Set address to correct value
loop2:
	mov	ecx,		3*201		; Set loop counter.
	cmp	edi,		esi		; Compare addresses
	jle	epilogue			; If edi is less than esi, finished. All swapped.
loop3:
	movzx	eax,		byte [esi]	; Load first
	movzx	ebx,		byte [edi]	; and second byte.
	; TODO: Change too full registers. 
	mov	byte [edi],	al		; Swap them,
	mov	byte [esi],	bl		; finish swap.
	inc 	edi,				; Advance to next byte
	inc	esi,				; in both addresses,
	loop	loop3				; and continue loop.

	sub	edi,		6*201		; EDI points one row higher now, so decrementing it by row is in practice decrementing it by 2 rows.
	jmp	loop2

epilogue:
	mov	eax, 		0		; Return 0.

	add	esp,		12		; Restore ESP.
	pop	ebp				; Restore EBP.
	ret


;============================================
; STOS
;============================================
;  |...                          |
;  | MapaStruct*                 | EBP+16
;  ------------------------------
;  | char* image                 | EBP+12
;  -------------------------------
;  | int mapa*	 		 | EBP+8
;  -------------------------------
;  | return address              | EBP+4
;  -------------------------------
;  | saved ebp                   | EBP
;  -------------------------------
;  | minimal value, x diff       | EBP-4
;  -------------------------------
;  | maximal value, y diff       | EBP-8
;  -------------------------------
;  | delta between min and max   | EBP-12
;  -------------------------------
;============================================
