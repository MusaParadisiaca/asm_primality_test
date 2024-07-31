INCLUDE Irvine32.inc
main EQU start@0

.data
	p	    DWORD   0
	base	DWORD	2, 7, 61
	s_input BYTE    "Please input the number to check (input 0 to exit): ", 0
	s_p	    BYTE	" is a prime.", 10, 10, "****************************************************************", 10, 10, 0
	s_np	BYTE	" is not a prime.", 10, 10, "****************************************************************", 10, 10, 0
.code

ModP_s	PROC
        cmp	edx, 0
        jnz	Sol
        div	p
        ret

Sol:	shr	ebx, 1
        rcr	ecx, 1
        cmp	edx, ebx
        jc	SkpSub
        jnz	DoSub
        cmp	eax, ecx
        jc	SkpSub

DoSub:	sub	eax, ecx
        jnc	NC
        sub	edx, 1
NC:	    sub	edx, ebx

SkpSub:	call	ModP_s
        ret
ModP_s	ENDP

ModP	PROC
        push	ebx
        push	ecx
        mov	ebx, p
        mov	ecx, 0
        push	eax
        mov	eax, edx
        mov	edx, 0
        div	p
        pop	eax
        call	ModP_s
        pop	ecx
        pop	ebx
        ret
ModP	ENDP

FastExp PROC
        push	ecx
        and	ecx, 1
        cmp	ecx, 1
        jnz	SkpFE

        mul	ebx
        call	ModP
        mov	eax, edx

SkpFE:	pop	ecx
        shr	ecx, 1
        cmp	ecx, 0
        jnz	Keep
        ret

Keep:	push	eax
        mov	eax, ebx
        mul	eax
        call	ModP
        mov	ebx, edx
        pop	eax
        call	FastExp

        ret
FastExp ENDP

main PROC

Input:	mov	edx, OFFSET s_input
        call    WriteString
        call	ReadInt
        cmp	eax, 0
        jnz	Begin
        ret

Begin:	mov	p, eax
        cmp	eax, 1
        jz	RS_NP
        cmp	eax, 2
        jz	RS_P
        test	eax, 1
        jz	RS_NP

        mov	esi, OFFSET base
Check:	mov	eax, 1
        mov	ebx, [esi]
        mov	ecx, p
        cmp	ebx, ecx
        jnc	RS_P
        dec	ecx
        call	FastExp
        cmp	eax, 1
        jnz	RS_NP
        add	esi, 4
        jmp	Check


RS_P:	mov	edx, OFFSET s_p
        jmp	Print

RS_NP:	mov	edx, OFFSET s_np

Print:	mov	eax, p
        call	WriteDec
        call	WriteString
        jmp	Input

main ENDP
END main

