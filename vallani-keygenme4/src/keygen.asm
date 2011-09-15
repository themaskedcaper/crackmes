; Target: KeyGenMe 4 by Vallani
; Type: KeygenMe
; Difficulty: 2
; Date: 06-08-09 17:55
; Author: Kilobyte
; count: #8

format PE Console 4.0
include '%fasminc%\win32ax.inc'
entry Main

section '.code' code readable executable

Main:
	cinvoke printf,p_name
	cinvoke printf,s_name
	cinvoke scanf,n_fmt,name_buff
	cinvoke strlen,name_buff
	cmp	eax,3
	jb	.nerror
	push	0
	call	Main.eflow	      ;calculate serial
	cinvoke wsprintf,serial,s_fmt,[s1]
	cinvoke printf,s_serial,serial
	jmp	.eproc
.nerror:
	cinvoke printf,n_error
.eproc:
	cinvoke getch
	invoke	ExitProcess,0
.eflow: 			 ;build Execution flow
	push	ebp
	mov	ebp,esp
	mov	eax,7F9h
	sub	[s1],eax
	xor	eax,eax
	bt	dword [s1],1
	adc	eax,0
	or	eax,eax
	jnz	 @f
	mov	[eflow],Summation.d1c0
	jmp	d2
    @@: mov	[eflow],Summation.d1c1
    d2: xor	eax,eax
	bt	dword [s1],2
	adc	eax,0
	or	eax,eax
	jnz	@f
	mov	[eflow+4],Summation.d2c0
	jmp	d3
    @@: mov	[eflow+4],Summation.d2c1
    d3: xor	eax,eax
	bt	dword [s1],3
	adc	eax,0
	or	eax,eax
	jnz	@f
	mov	[eflow+8],Summation.d3c0
	jmp	.next
    @@: mov	[eflow+8],Summation.d3c1

.next:
	cmp	byte [ebp+8],0
	;cmp      byte [infunc],0
	jne	.exitse
.calcSerial:
	mov	eax,dword [oname]
	movzx	ebx,byte [eax]
	movzx	ecx,byte [eax+1]
	shl	ebx,5h
	add	ebx,2328h
	add	ebx,ecx
	xor	ecx,00BC614Eh
	imul	ebx,ebx,0Dh
	xor	ebx,00015587h
	push	ecx
	push	ebx
	call	Recurse
	xor	eax,dword [s1]
	mov	dword [s1],eax
	inc	[oname]
	mov	eax,dword [oname]
	inc	eax
	cmp	byte [eax],0
	je	.exit
	push	0
	call	Main.eflow
	jmp	.exit
.exitse:
	mov	ebp,dword [se]
	mov	eax,dword [retaddr]
	mov	dword [ebp+4],eax
.exit:	leave
	retn	4

Recurse:
	push	ebp
	mov	ebp,esp
	mov	eax,[ebp+8]
	mov	dword [tmp],eax
	cmp	dword [ebp+0Ch],0
	je	.exit
	push	dword [ebp+8]
	call	Summation
	mov	eax,dword [tmp]
	cdq
	idiv	dword [ebp+0Ch]
	push	edx
	push	dword [ebp+0Ch]
	call	Recurse
	jmp	.exit
	mov	eax,[tmp]
   .exit:
	leave
	retn	8


Summation:
	push	ebp
	mov	ebp,esp
	push	dword [ebp+4]
	push	ebp
	mov	eax,Main.eflow
	mov	dword [ebp+4],eax
	mov	eax,[ebp+8]
	jmp	[eflow]
.d1c0:
	add	eax,[s1]
	movzx	ecx,byte [s1]
	imul	eax,eax,2099h
	shr	eax,3h
    @@: sub	eax,3h
	loop	@b
	jmp	[eflow+4]
.d1c1:
	movzx	ecx,word [s1]
	add	ecx,1538h
	and	ecx,7A2B36FFh
	xor	eax,ecx
	imul	eax,[s1]
	jmp	[eflow+4]
.d2c0:
	xor	eax,00001AFh
	mov	ebx,eax
	rol	eax,6
	bswap	eax
	or	eax,0000066Ah
	jmp	[eflow+8]
.d2c1:
	sub	eax,ecx
	shl	eax,7
	add	eax,17F4Bh
	movzx	ecx,ax
	ror	cx,5
	add	eax,ecx
	jmp	[eflow+8]
.d3c0:
	mov	ebx,11h
	mov	ecx,eax
	cdq
	idiv	ebx
	bt	ecx,edx
	xchg	eax,ecx
	adc	eax,2h
	jmp	.done
.d3c1:
	movzx	ecx,ax
	not	cx
    @@: sub	eax,0B9h
	xor	eax,ecx
	loop	@b
	jmp	.done
.done:
	mov	[s1],eax
	mov	dword [ebp+8],1
	mov	dword [infunc],1
	pop	[se]
	pop	[retaddr]
	leave
	;jmp      .eflow
	retn	4h

section '.data' readable writeable
p_name	db "Vallani's KeyGenMe 4 Keygen By Kilobyte",13,10,0
n_fmt	db '%s',0
s_fmt	db '%u',0
n_error db 'name must be greater than 2',13,10,0
s_name	db 'Name: ',0
s_serial db 'Serial: %s',13,10,0
;-----------------------------
s1	dd 0
eflow	dd 0
	dd 0
	dd 0
tmp	dd 0
retaddr dd 0
se	dd 0
infunc	dd 0
oname	dd name_buff

dd 0
dd 0
dd 0
name_buff  rb 64	;ample enough?
serial	rb 64		;:P

section '.idata' import data readable writeable

library Kernel32,'Kernel32.dll',\
	User32,'User32.dll',\
	MSVCRT,'MSVCRT.dll'

import Kernel32,\
       ExitProcess,'ExitProcess'

import User32,\
       wsprintf,'wsprintfA'

import MSVCRT,\
       printf,'printf',\
       sprintf,'sprintf',\
       scanf,'scanf',\
       getch,'_getch',\
       strlen,'strlen'