;=====================================================================
; Wiktor Sleczka
;
; Project x86 2.6
; Height map generator.
;=====================================================================

section	.text
global  func

func:
	;prologue
	push	ebp
	mov	ebp,	 esp
	sub	esp,	 4
	
	;body
	mov	ebx,	 	dword [ebp+8]	; Load start of array
	movzx	eax,		byte [ebx]	; Load first byte
	test	eax,		eax		; Check if zero
	jz	end				; then string is empty, no sorting needed.
	inc	ebx,				; Move to next addres.
	movzx	eax,		byte [ebx]	; else load second byte
	test	eax, 		eax		; Check if zero
	jz	end				; then one element array, no jump needed.
						; else sort array.
loop1:
	mov	dword [ebp-4],	0		; Store sorted indicator
	mov	ebx,		dword [ebp+8]	; Load array start
	dec	ebx
loop2:
	inc	ebx
	mov	al,		byte [ebx]	; Save first array element.
	mov	ah,		byte [ebx+1]	; Save second array element.
	test	ah,		ah		; If second element is 0
	jz	break1				; Break from loop
	cmp	ah,		al		; If second element is greater than first
	jge	loop2				; continue the loop,
						; else swap elements
	mov	byte [ebx+1],	al		; Save element 1 in position of 2
	mov	byte [ebx],	ah		; and element 2 in position of 1
	mov	dword [ebp-4],	1		; set register as changed
	jmp	loop2				; and continue the loop
break1:
	mov	eax,		dword [ebp-4]	; Load indicator's value
	test	eax,		eax		; If indicator is set
	jnz	loop1				; continue loop
						; else break off.
end:
	;epilogue
	mov	eax, 	0			; Return 0

	add	esp,	4
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
