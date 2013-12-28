;=====================================================================
; Wiktor Sleczka
;
; Project x86 2.6
; Height map generator.
;=====================================================================

section	.text
global  przekroj

przekroj:
	;prologue
	push	ebp
	mov	ebp,		esp
	sub	esp,		4

	;body
	; Prepare bitmap.
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+8]	; Load x1
	sub	eax,		dword [ebx+12]	; Count length of x
	jns	x_positive			; If negative
	neg	eax				; take negation of length.
x_positive:
	push	eax				; Store length of x
	mov	eax,		dword [ebx+16]	; Load y1
	sub	eax,		dword [ebx+20]	; Count length of y
	jns	y_positive			; If negative
	neg	eax				; take negation of length.
y_positive:
	pop	edx				; Restore x length.
	cmp	eax,		edx		; Compare lengths

end:
	;epilogue
	mov	eax, 	0			; Return 0

	pop	ebp
	ret

;============================================
; STOS
;============================================
;
; wieksze adresy
; 
;  | ...                         |
;  | PrzekrojStruct              | EBP+16
;  ------------------------------
;  | char* image                 | EBP+12
;  -------------------------------
;  | int* mapa	                 | EBP+8
;  -------------------------------
;  | adres powrotu               | EBP+4
;  -------------------------------
;  | zachowane ebp               | EBP, ESP
;  -------------------------------
;  | ... tu ew. zmienne lokalne  | EBP-x
;  |                             |
;
; \/                         \/
; \/ w ta strone rosnie stos \/
; \/                         \/
;
; mniejsze adresy
;
;
;============================================
