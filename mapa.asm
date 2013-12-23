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
	mov	ebx,		dword [ebp+8]	; Load address of struct informations.
	mov	eax,		dword [ebx]	; Load minimal value.
	mov	dword [ebp-4],	eax		; Store minimal value.
	mov	eax,		dword [ebx+4]	; Load maximal value.
	mov	dword [ebp-8],	eax		; Store maximal value.
	sub	eax,		dword [ebp-4]	; Count difference between max and min.
	mov	dword [ebp-12],	eax		; Store difference.

	; Prepare for loop
	mov	ecx,		201*201		; Load loop counter
	mov	esi,		dword [ebp+16]	; Load source address.
	mov	edi,		dword [ebp+12]	; Load destination address.
	cld					; Clear destination flag.
loop1:
	lodsd					; Load first number into accumulator.
	mov	ebx,		dword [ebp-8]	; Load maximal value.
	cmp	eax,		ebx		; Compare value with maximal
	jge	put_black			; if higher than maximal, simply put black.
	sub	eax,		dword [ebp-4]	; Substract minimal value from current.
	js	put_white			; If result negative, simply put white.

loop1_continue:
	stosd					; Store result value
	stosd					; for every color in rgb,
	stosd					; so three times.
	loop	loop1				; Decrement loop counter and jump loop1 if nonzero.

	; epilogue
	mov	eax, 		0		; Return 0.

	add	esp,		12		; Restore ESP.
	pop	ebp				; Restore EBP.
	ret

; Here some helper methods.
; For loop1:
put_black:
	mov	eax,		0		; Store 0s
	jmp	loop1_continue			; Continue the loop.
put_white:
	mov	eax,		-1		; Store 1s
	jmp	loop1_continue			; Continue loop.

;============================================
; STOS
;============================================
;  |...                          |
;  | int* mapa                   | EBP+16
;  ------------------------------
;  | char* image                 | EBP+12
;  -------------------------------
;  | MapaStruct* 		 | EBP+8
;  -------------------------------
;  | return address              | EBP+4
;  -------------------------------
;  | saved ebp                   | EBP
;  -------------------------------
;  | minimal value               | EBP-4
;  -------------------------------
;  | maximal value               | EBP-8
;  -------------------------------
;  | delta between min and max   | EBP-12
;  -------------------------------
;============================================
