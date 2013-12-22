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
	sub	esp,		20		; Five integer local variables.

	; body
	mov	ebx,		dword [ebp+8]	; Load address of struct informations.
	mov	eax,		dword [ebx]	; Load minimal value.
	mov	dword [ebp-4],	eax		; Store minimal value.
	mov	eax,		dword [ebx+4]	; Load maximal value.
	mov	dword [ebp-8],	eax		; Store maximal value.
	sub	eax,		dword [ebp-4]	; Count difference between max and min.
	mov	dword [ebp-12],	eax		; Store difference.
	mov	eax,		dword [ebp+16]	; Load source address.
	mov	dword [ebp-16], eax		; Store source address in local variable.
	mov	eax,		dword [ebp+12]	; Load target address.
	mov	dword [ebp-20],	eax		; Store target address in local variable.

	; epilogue
	mov	eax, 	0			; Return 0.

	add	esp,	12			; Reset ESP.
	pop	ebp				; Restore EBP.
	ret

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
;  | pointer to source array	 | EBP-16
;  -------------------------------
;  | pointer to target bitmap    | EPB-20, ESP
;  -------------------------------
;============================================
