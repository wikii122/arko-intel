;=====================================================================
; Wiktor Sleczka
;
; Project x86 2.6
; Height map generator.
;=====================================================================

section	.text
global  mapa

mapa:
	;prologue
	push	ebp
	mov	ebp,	 esp

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
;  |                             |
;  | ...                         |
;  -------------------------------
;  | parametr funkcji - char *a  | EBP+8
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
