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
	mov	ebx,		16
	sub	esp,		ebx
	push	ebx

	;body
	; Prepare bitmap.
	mov	edx,		0		; Zero edx (multiplication).
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	edi,		dword [ebp+12]	; Load target struct.
	mov	ecx,		dword [ebx]	; Load length of line.
	mov	dword [ebp-16],	ecx		; Store length.
	push	ecx				; Store row length.
	mov	eax,		400*3		; Constant heigth * bit per pixel.
	mul	ecx				; Count number of bits in bitmap.
	mov	ecx,		eax		; Set number of bits as loop counter.
	mov	eax,		-1		; Fill eax with 1s.
loop_init:
	stosb					; Store 1s in data array.
	loop	loop_init			; Continue for every byte.

	pop	eax				; Restore row length.
	mov	ebx,		3		; Store no bytes/pixel.
	mul	ebx				; Count row length in bytes.
	mov	ecx,		eax		; Backup eax.
	mov	ebx,		4		; Check, if length is evenly divisable by 4.
	div	ebx				;
	mov	eax,		ecx		;
	test	edx,		edx		; 
	jz	even				; else round to next 
	shr	eax,		2		; Round two four bytes
	inc	eax				; and move two next byte
	shl	eax,		2		; 
even:
	mov	dword [ebp-4],	eax		; Store row length.

	; Count array start
	mov	ebx,		dword [ebp+16]	; Load addres of help struct.
	
	mov	eax,		dword [ebx+16]	; Load y1
	mov	ecx,		201*4		; Load row length.
	mul	ecx				; Count y offset.
	push	eax				; Store y offset.

	mov	eax,		dword [ebx+8]	; Load x1
	mov	ecx,		4		; Load item length.
	mul	ecx				; Count x offset.
	
	pop	ecx				; Restore y offset.
	add	eax,		ecx		; Count whole offset.
	add	eax,		dword [ebp+8]	; Count start address.
	push	eax				; Store source address start.
	
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+12]	; Load x1
	sub	eax,		dword [ebx+8]	; Count length of x
	jns	x_positive			; If negative
	neg	eax				; take negation of length.
x_positive:
	push	eax				; Store length of x
	mov	eax,		dword [ebx+20]	; Load y1
	sub	eax,		dword [ebx+16]	; Count length of y
	jns	y_positive			; If negative
	neg	eax				; take negation of length.
y_positive:
	pop	edx				; Restore x length.
	cmp	eax,		edx		; Compare lengths
	jg	draw_by_y			; If y is longer, jump draw by y heigth.

draw_by_x:
	pop	esi				; Restore source address.
	mov	edi,		dword [ebp+12]	; Store start of target array.
	mov	ecx,		0		; Zero loop counter.

	; Count x length.
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+12]	; Load x2
	sub	eax,		dword [ebx+8]	; Substract x1 from x2.
	mov	dword [ebp-8],	eax		; Store x length.

	; Count y length.
	mov	eax,		dword [ebx+20]	; Load y2
	sub	eax,		dword [ebx+16]	; Substract y2 from x2.
	mov	dword [ebp-12],	eax		; Store y length.
	mov	ebx,		0		; Store x offset
	mov	edx,		0		; Store y offset.
loop_draw_x:
	mov	eax,		ebx		; Store x offset.
	push	edx				; Store y offset
	mov	ebx,		201		; Store row length
	mul	ebx
	pop	edx
	add	eax,		edx		; Calculate offset by adding y's.
	mov	ebx,		4		; Adapt to int size
	mul	ebx
	mov	eax,		dword [esi+eax]	; Load value of field.
	cmp	eax,		0		; Check if heigth should be marked.
	jl	pass_x				
	cmp	eax,		400
	jg	pass_x		
	mul	dword [ebp-4]			; Count offset to value.
	add	eax,		edi		; Count correct address
	mov	byte [eax],	0		; Store 0s in appropiate fields.
	mov	byte [eax+1],	0		; 
	mov	byte [eax+2],	0		;
pass_x:
	add	edi,		3		; Move to next 3 bytes.
	inc	ecx				; Increment loop counter.
	cmp	ecx,		dword [ebp-16]	; If loop counter
	jge	end				; is equal length of line, finish,
						; else
	mov	eax,		ecx		; Store step indicator for calculations.
	imul	dword [ebp-8]			; Calculate new offset 
	idiv	dword [ebp-16]			; from proportion step_no * len_x / length.
	push	eax				; Store x offset.
	
	imul	dword [ebp-12]			; Count new offset
	idiv	dword [ebp-8]			; x_offset * len_y / len_x
	
	mov	edx,		eax		; Move y  offset to correct register.
	pop	ebx				; Restore x offset to correct register.
	jmp	loop_draw_x

draw_by_y:
	pop	esi				; Restore source address.
	mov	edi,		dword [ebp+12]	; Store start of target array.
	mov	ecx,		0		; Zero loop counter.

	; Count x length.
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+12]	; Load x2
	sub	eax,		dword [ebx+8]	; Substract x1 from x2.
	mov	dword [ebp-8],	eax		; Store x length.

	; Count y length.
	mov	eax,		dword [ebx+20]	; Load y2
	sub	eax,		dword [ebx+16]	; Substract y2 from x2.
	mov	dword [ebp-12],	eax		; Store y length.
	mov	ebx,		0		; Store x offset
	mov	edx,		0		; Store y offset.
loop_draw_y:
	mov	eax,		ebx		; Store x offset.
	push	edx				; Store y offset
	mov	ebx,		201		; Store row length
	mul	ebx
	pop	edx
	add	eax,		edx		; Calculate offset by adding y's.
	mov	ebx,		4		; Adapt offset to integer type
	mul	ebx
	mov	eax,		dword [esi+eax]	; Load value of field.
	cmp	eax,		0		; Check if heigth should be marked.
	jl	pass_y				
	cmp	eax,		400
	jg	pass_y		
	mov	edx,		0
	mul	dword [ebp-4]			; Count offset to value.
	add	eax,		edi		; Count correct address
	mov	byte [eax],	0		; Store 0s in appropiate fields.
	mov	byte [eax+1],	0		; 
	mov	byte [eax+2],	0		;
pass_y:
	add	edi,		3		; Move to next 3 bytes.
	inc	ecx				; Increment loop counter.
	cmp	ecx,		dword [ebp-16]	; If loop counter
	jge	end				; is equal length of line, finish,
						; else
	mov	eax,		ecx		; Store step indicator for calculations.
	imul	dword [ebp-12]			; Calculate new offset 
	idiv	dword [ebp-16]			; from proportion step_no * len_y / length.
	push	eax				; Store x offset.
	
	imul	dword [ebp-8]			; Count new offset
	idiv	dword [ebp-12]			; y_offset * len_x / len_y
	
	mov	ebx,		eax		; Move x  offset to correct register.
	pop	edx				; Restore y offset to correct register.
	jmp	loop_draw_y

end:
	;epilogue
	mov	eax, 	0			; Return 0

	pop	ebx
	add	esp, 	ebx
	pop	ebp
	ret

;============================================
; STACK
;============================================
;  | ...                         |
;  | PrzekrojStruct              | EBP+16
;  ------------------------------
;  | char* image                 | EBP+12
;  -------------------------------
;  | int* mapa	                 | EBP+8
;  -------------------------------
;  | return address              | EBP+4
;  -------------------------------
;  | saved ebp                   | EBP
;  -------------------------------
;  | row length in pixels        | EBP-4
;  -------------------------------
;  | x2-x1                       | EBP-8
;  -------------------------------
;  | y2-y1                       | EBP-12
;  -------------------------------
;  | Length of line              | EBP-16
;  |\/ \/ \/ \/ \/ \/ \/ \/ \/ \/|
;============================================
