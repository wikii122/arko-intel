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
	jmp	put_byte_ret			; Return after if stamenment.
loop1:
	lodsd					; Load first number into accumulator.
	cmp	eax,		dword [ebp-8]	; Compare value with maximal
	jg	put_white			; if higher than maximal, simply put black.
	sub	eax,		dword [ebp-4]	; Substract minimal value from current.
	js	put_black			; If result negative, simply put white.

	; Calculate correct value if not special case.
	push	ebx				; Store row counter
	mov	ebx,		255
	mul	ebx,				; Normalization of value to 255.
	div	dword [ebp-12]
	pop	ebx				; Restore row counter.

loop1_continue:
	mov	byte [edi],	al		; Save result
	mov	byte [edi+1],	al		; three times,
	mov	byte [edi+2],	al		; once for each color.
	add	edi,		3		; and increment target counter.
	inc	ebx				; Increment row counter.
	cmp	ebx,		201		; Check if empty byte should be given.
	je	put_byte			; Put one byte at the end of row.
put_byte_ret:
	loop	loop1				; Decrement loop counter and jump loop1 if nonzero.

	; Draw line.
draw:
	mov	ebx,		dword [ebp+16]	; Load address of help struct.
	; Calculate start of line.
	mov	eax,		dword [ebx+16]	; Load x start.
	mov	ebx,		dword [ebp+12]	; Load start of map.
	mov	ecx,		604		; Store multiply value
	mul	ecx				; Multiply by value
	push	eax				; Store result on stack
	mov	ebx,		dword [ebp+16]	; Load address of help struct.
	mov	eax,		dword [ebx+8]	; Load y start.
	mov	ebx,		dword [ebp+12]	; Load start of map.
	mov	edx,		0		; Now multiply by
	mov	ecx,		3		; 3 taking care y offset
	mul	ecx				; multiply.
	pop	edx				; Restore saved value.
	lea	ebx,		[ebx+eax]	; Load address of starting position.
	lea	ebx,		[ebx+edx]
	; Current eax is address of [map start]+(3*201+1)*[y start]+3*[x start]
	push	ebx				; Store address of starting position.

	mov	ebx,		dword [ebp+16]	; Load address of help struct.
	mov	eax,		dword [ebx+8]	; Load x start.
	sub	eax,		dword [ebx+12]	; Count x length.
	jns	draw_positive_x			; If less than 0
	neg	eax				; negate length,
draw_positive_x:				; else continue.
	mov 	edx,		eax		; Backup x lengthv in edx.
	mov	eax,		dword [ebx+16]	; Load y start
	sub	eax,		dword [ebx+20]	; and count y length.
	jns	draw_positive_y			; If less than 0
	neg	eax				; negate length,
draw_positive_y:				; else continue.
	mov	dword [ebp-8],	eax		; Store length of y.
	mov	dword [ebp-4],	edx		; Store length of x.
	cmp	eax,		edx		; Compare x and y length,
	jge	draw_by_y			; if length of x is greater, draw by y.

draw_by_x:
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+16]	; Load y1
	sub	eax,		dword [ebx+20]	; Count y length.
	neg	eax				; Negate it
	mov	dword [ebp-8],	eax		; and store it as length of y.
	mov	ecx,		0		; Zero the loop counter.
	mov	dword [ebp-12],	3		; Store move indicator.
	pop	ebx				; Restore starting position.
	mov	eax,		ebx		; Copy ebx to eax, for future use.
	mov	esi,		dword [ebp+16]	; Load help struct.
	mov	edx,		dword [esi+8]	; Load x1 value.
	sub	edx,		dword [esi+12]	; Count length again.
	js	draw_by_x_pos			; If length is negative, change move indicator.
	mov	dword [ebp-12],	-3		; to -one row.
draw_by_x_pos:
	mov	byte [eax],	0		; Store blue.
	mov	byte [eax+1],	0		; Store green.
	mov	byte [eax+2],	-1		; Store red.
	inc	ecx				; Increment loop counter
	add	ebx,		dword [ebp-12]	; Increment pointer by value.
	push	ebx				; Store array address.
	mov	eax,		ecx		; Copy value of eax to further calculation.
	imul	dword [ebp-8]			; Calculate new y using proportion
	idiv	dword [ebp-4]			; of original x/y.
	mov	ebx,		(3*201+1)	; Count y offset.
	imul	ebx				; by multiplying by number of bytes in row.
	pop	ebx				; Restore original address.
	add	eax,		ebx		; Count new position.
	cmp	ecx,		dword [ebp-4]	; Check if
	jle	draw_by_x_pos			; loop is finished.
	jmp	swap				; Continue running.

draw_by_y:
	mov	ebx,		dword [ebp+16]	; Load help struct.
	mov	eax,		dword [ebx+8]	; Load x1
	sub	eax,		dword [ebx+12]	; Count x length.
	neg	eax				; Negate it
	mov	dword [ebp-4],	eax		; and store it as length of y.
	jmp	draw_by_y_continue		; Then continue.
draw_by_y_continue:
	mov	ecx,		0		; Zero the loop counter.
	mov	dword [ebp-12],	(3*201+1)	; Store move indicator.
	pop	ebx				; Restore starting position.
	mov	eax,		ebx		; Copy ebx to eax, for future use.
	mov	esi,		dword [ebp+16]	; Load help struct.
	mov	edx,		dword [esi+16]	; Load y1 value.
	sub	edx,		dword [esi+20]	; Count length again.
	js	draw_by_y_pos			; If length is negative, change move indicator.
	mov	dword [ebp-12],	-(3*201+1)	; to -one row.

draw_by_y_pos:
	mov	byte [eax],	0		; Store blue.
	mov	byte [eax+1],	0		; Store green.
	mov	byte [eax+2],	-1		; Store red.
	inc	ecx				; Increment loop counter
	mov	eax,		ecx		; Copy value of eax to further calculation.
	imul	dword [ebp-4]			; Calculate new y using proportion
	idiv	dword [ebp-8]			; of original x/y.
	add	ebx,		dword [ebp-12]	; Increment pointer by value.
	push	ebx				; Store original position
	mov	ebx,		3		; Calculate x offset
	imul	ebx				; by multiplaying offset by number of bytes per color.
	pop	ebx				; Restore the originaladdress.
	add	eax,		ebx		; Count address with offset in eax.
	cmp	ecx,		dword [ebp-8]	; Check if
	jle	draw_by_y_pos			; loop is finished.
	jmp	swap				; Continue running.

	; Swap rows.
swap:
	mov	esi,		dword [ebp+12]	; Load beginning of the file
	mov	edi,		esi		; Copy it to the second register
	add	edi,		200*(201*3+1)	; Set address to correct value
loop2:
	mov	ecx,		3*201+1		; Set loop counter.
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

	sub	edi,		6*201+2		; EDI points one row higher now, so decrementing it by row is in practice decrementing it by 2 rows.
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
;  | minimal value, x start      | EBP-4
;  -------------------------------
;  | maximal value, y start      | EBP-8
;  -------------------------------
;  | delta min-max, difference   | EBP-12
;  -------------------------------
;============================================
