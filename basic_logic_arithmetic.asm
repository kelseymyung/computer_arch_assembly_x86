TITLE Project 1 - Basic Logic & Arithemtic Program     (Proj1_collikel.asm)

; Author: Kelsey Ann Myung Collins	
; Last Modified: January 21, 2023
; OSU email address: collikel@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                 Due Date: January 29, 2023
; Description: Executes elementary MASM programming and integer arithmetic operations

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

intro_1				BYTE	"Basic Arithmetic Program by Kelsey Ann Myung Collins",0	; program name and programmer name
ec_intro_1			BYTE	"**EC: Program verifies the numbers are in descending order.",0
ec_intro_2			BYTE	"**EC: Program calculates and displays the quotients A/B, A/C, B/C.",0
intro_2				BYTE	"Please enter 3 numbers down below. Guidelines: A > B > C. I will show you the sums and differences.",0		; instructions for user
prompt_1			BYTE	"First number (A): ",0
input_1a			DWORD	?							; first number A, entered by user
prompt_2			BYTE	"Second number (B): ",0
input_2b			DWORD	?							; second number B, entered by user
prompt_3			BYTE	"Third number (C): ",0
input_3c			DWORD	?							; third number C, entered by user
error_desc			BYTE	"ERROR: The numbers are not in descending order!",0
a_plus_b			DWORD	?							; to be calculated
a_minus_b			DWORD	?							; to be calculated
a_plus_c			DWORD	?							; to be calculated
a_minus_c			DWORD	?							; to be calculated
b_plus_c			DWORD	?							; to be calculated
b_minus_c			DWORD	?							; to be calculated
a_plus_b_plus_c		DWORD	?							; to be calculated
a_div_b				DWORD	?							; to be calculated
a_div_b_remain		DWORD	?							; to be calculated
a_div_c				DWORD	?							; to be calculated
a_div_c_remain		DWORD	?							; to be calculated
b_div_c				DWORD	?							; to be calculated
b_div_c_remain		DWORD	?							; to be calculated
plus_sign			BYTE	" + ",0
minus_sign			BYTE	" - ",0
equal_sign			BYTE	" = ",0
divide_sign			BYTE	" / ",0
remainder_txt		BYTE	" with remainder of ",0	
outro_1				BYTE	"Thank you for using this program! Goodbye!",0


.code
main PROC

; introduction
	MOV		EDX, OFFSET	intro_1
	call	WriteString
	call	Crlf
	call	Crlf
	mov		EDX, OFFSET	ec_intro_1
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET	ec_intro_2
	call	WriteString
	call	Crlf
	call	Crlf
	MOV		EDX, OFFSET	intro_2
	call	WriteString
	call	Crlf
	call	Crlf


; get the data
	MOV		EDX, OFFSET prompt_1
	call	WriteString
	call	ReadDec
	MOV		input_1a, EAX
	MOV		EDX, OFFSET prompt_2
	call	WriteString
	call	ReadDec
	MOV		input_2b, EAX
	; verify data requirements A > B
	mov		EAX, input_1a
	CMP		EAX, input_2b
	JBE		_NotDescending		; input B is greater than or equal to input A, ends program
	MOV		EDX, OFFSET prompt_3
	call	WriteString
	call	ReadDec
	MOV		input_3c, EAX
	; verify data requirements B > C
	mov		EAX, input_2b
	CMP		EAX, input_3c
	JBE		_NotDescending		; input C is greater than or equal to input B, ends program
	call	Crlf



; calculate the required values
	; addition
	mov		EAX, input_1a	; A + B
	mov		EBX, input_2b
	add		EAX, EBX
	mov		a_plus_b, EAX
	mov		EAX, input_1a	; A + C
	mov		EBX	, input_3c
	add		EAX, EBX
	mov		a_plus_c, EAX	
	mov		EAX, input_2b	; B + C
	mov		EBX, input_3c
	add		EAX, EBX
	mov		b_plus_c, EAX	
	mov		EAX, a_plus_b	; A + B + C
	mov		EBX, input_3c
	add		EAX, EBX
	mov		a_plus_b_plus_c, EAX
	; subtraction
	mov		EAX, input_1a	; A - B
	mov		EBX, input_2b
	sub		EAX, EBX
	mov		a_minus_b, EAX
	mov		EAX, input_1a	; A - C
	mov		EBX, input_3c
	sub		EAX, EBX
	mov		a_minus_c, EAX
	mov		EAX, input_2b	; B - C
	mov		EBX, input_3c
	sub		EAX, EBX
	mov		b_minus_c, EAX
	; division
	mov		EAX, input_1a	; A / B
	mov		EDX, 0
	mov		EBX, input_2b
	DIV		EBX
	mov		a_div_b, EAX
	mov		a_div_b_remain, EDX
	mov		EAX, input_1a	; A / C
	mov		EDX, 0
	mov		EBX, input_3c
	DIV		EBX
	mov		a_div_c, EAX
	mov		a_div_c_remain, EDX
	mov		EAX, input_2b	; B / C
	mov		EDX, 0
	mov		EBX, input_3c
	DIV		EBX
	mov		b_div_c, EAX
	mov		b_div_c_remain, EDX


; display the results
	; A + B
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET plus_sign
	call	WriteString
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, a_plus_b
	call	WriteDec
	call	Crlf
	; A - B
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET minus_sign
	call	WriteString
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET equal_sign
	call	WriteString
	mov		EAX, a_minus_b
	call	WriteDec
	call	Crlf
	; A + C
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET plus_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, a_plus_c
	call	WriteDec
	call	Crlf
	; A - C
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET minus_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET equal_sign
	call	WriteString
	mov		EAX, a_minus_c
	call	WriteDec
	call	Crlf
	; B + C
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET plus_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, b_plus_c
	call	WriteDec
	call	Crlf
	; B - C
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET minus_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET equal_sign
	call	WriteString
	mov		EAX, b_minus_c
	call	WriteDec
	call	Crlf
	; A + B + C
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET plus_sign
	call	WriteString
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET plus_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET equal_sign
	call	WriteString
	mov		EAX, a_plus_b_plus_c
	call	WriteDec
	call	Crlf
	; A / B
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET divide_sign
	call	WriteString
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, a_div_b
	call	WriteDec
	mov		EDX,OFFSET remainder_txt
	call	WriteString
	mov		EAX, a_div_b_remain
	call	WriteDec
	call	Crlf
	; A / C
	mov		EAX, input_1a
	call	WriteDec
	mov		EDX, OFFSET divide_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, a_div_c
	call	WriteDec
	mov		EDX,OFFSET remainder_txt
	call	WriteString
	mov		EAX, a_div_c_remain
	call	WriteDec
	call	Crlf
	; B / C
	mov		EAX, input_2b
	call	WriteDec
	mov		EDX, OFFSET divide_sign
	call	WriteString
	mov		EAX, input_3c
	call	WriteDec
	mov		EDX, OFFSET	equal_sign
	call	WriteString
	mov		EAX, b_div_c
	call	WriteDec
	mov		EDX,OFFSET remainder_txt
	call	WriteString
	mov		EAX, b_div_c_remain
	call	WriteDec
	call	Crlf
	call	Crlf


; say goodbye
	MOV		EDX, OFFSET	outro_1
	call	WriteString
	call	Crlf
	JMP		_Finished	

_NotDescending:			; if data requirements are not met A > B > C, ends program with error message
	call	Crlf
	mov		EDX, OFFSET error_desc
	call	WriteString
	call	Crlf

_Finished:


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
