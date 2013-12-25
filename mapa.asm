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
	cld					; Clear destination flag.
	jmp	loop1				; jump to the loop.

put_black:
	mov	eax,		0		; Store 0s
	jmp	loop1_continue			; Continue the loop.

put_white:
	mov	eax,		-1		; Store 1s
	jmp	loop1_continue			; Continue loop.

loop1:
	lodsd					; Load first number into accumulator.
debug:
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
	loop	loop1				; Decrement loop counter and jump loop1 if nonzero.
;TODO: remove
	jmp	epilogue
	; Now draw red line.
	mov	eax,		dword [ebx+20]	; Load first value for y.
	sub	eax,		dword [ebx+16]	; Count y length of line.
	mov	dword [ebp-8],	eax		; Store result

	mov	ebx,		dword [ebp+8]	; Load data struct address.
	mov	eax,		dword [ebx+12]	; Load first value for x.
	sub	eax,		dword [ebp+8]	; Count x length of line.
	mov	dword [ebp-4],	eax		; Store result
	idiv	dword [ebp-8]			; Count tangens of the line.

	cmp	eax,		1		; If tangens is greater or equal than 1,
	jge	draw_by_y			; Line should be drawn by ys.
	cmp	eax,		-1		; else if tangens
	jl	draw_by_y			; is less than -1, the also draw by ys.
draw_by_x:
draw_by_y:
	
; TODO: Swap rows.
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
