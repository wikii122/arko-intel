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
	mov	ebx,		4
	sub	esp,		ebx
	push	ebx

	;body
	; Prepare bitmap.
	mov	edx,		0		; Zoro edx (multiplication).
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	edi,		dword [ebp+12]	; Load target struct.
	mov	ecx,		dword [ebx]	; Load length of line.
	shl	ecx,		2		; Round two four bytes
	inc	ecx				; and move two next byte
	shr	ecx,		2		; 
	mov	eax,		400*3		; Constant heigth * bit per pixel.
	mul	ecx				; Count number of bits in bitmap.
	mov	ecx,		eax		; Set number of bits as loop counter.
	mov	eax,		-1		; Fill eax with 1s.
loop_init:
	stosb					; Store 1s in data array.
	loop	loop_init			; Continue for every byte.

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

	pop	ebx
	add	esp, 	ebx
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
