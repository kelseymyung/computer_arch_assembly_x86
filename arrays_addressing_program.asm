TITLE Project 5 - The Random Array Program     (Proj5_collikel.asm)

; Author: Kelsey Ann Myung Collins
; Last Modified: March 7, 2023
; OSU email address: collikel@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 5                Due Date: March 5, 2023 - extended to March 7, 2023
; Description: This program generates a randomized array of 200 numbers. The program will
;				display the array, sort it in ascending order, calculate the median, and display
;				the array count of how many times a value appears

INCLUDE Irvine32.inc

ARRAYSIZE = 200
LO = 15
HI = 50

.data

intro_1		BYTE	"The Random Array Program by Kelsey Ann Myung Collins",13,10,13,10,"This program will create a list of 200 random numbers between 15 and 50, inclusive.",13,10,
					"It displays three lists: the original array, the array sorted in ascending order",13,10,
					"and an array that holds the number of instances of each generated value, starting with the lowest value.",13,10,
					"It also displays the median value of the list.",13,10,13,10,0
randArray	DWORD	ARRAYSIZE DUP(?)
upper_bound	DWORD	?
randTitle	BYTE	"The unsorted array: ",13,10,0
space		BYTE	" ",0
lineCount	DWORD	20
sortTitle	BYTE	"The sorted array: ",13,10,0
lenArray	DWORD	?
type_arr	DWORD	?
med_text	BYTE	"The median value of the array: ",0
countTitle	BYTE	"The list of instances of each generated number, starting with the smallest value:",13,10,0
countArray	DWORD	ARRAYSIZE DUP(?)
goodbye		BYTE	"I hope you enjoyed this program. Goodbye!",0

.code
;----------------------------------------------------------------------------------------
;Name: main
;
;Calls the procedures of the program in sequential order
;
;Preconditions: None
;
;Postconditions: None
;
;Receives: None
;
;Returns: None
;----------------------------------------------------------------------------------------
main PROC
	; introduction
	push	offset intro_1
	call	introduction

	call	Randomize

	; fillArray
	push	offset randArray
	; identify upper_bound of range when considering LO
	mov		ebx, HI
	sub		ebx, LO
	mov		upper_bound, ebx
	inc		upper_bound
	push	upper_bound
	call	fillArray

	;displayList
	mov		lenArray, ARRAYSIZE
	push	offset randTitle
	push	offset randArray
	push	lenArray
	push	offset space
	push	lineCount
	call	displayList

	; sortList
	push	offset randArray
	call	sortList

	; displayList
	push	offset sortTitle
	push	offset randArray
	push	lenArray
	push	offset space
	push	lineCount
	call	displayList

	; displayMedian
	mov		type_arr, TYPE randArray
	push	type_arr
	push	offset med_text
	push	offset randArray
	call	displayMedian

	; countList
	push	offset randArray
	push	offset countArray
	call	countList

	; displayList
	; calculate length of countArray
	mov		eax, HI
	sub		eax, LO
	inc		eax
	mov		lenArray, eax
	push	offset countTitle
	push	offset countArray
	push	lenArray
	push	offset space
	push	lineCount
	call	displayList

	; farewell
	push	offset goodbye
	call	farewell

	Invoke ExitProcess,0	; exit to operating system

main ENDP

;----------------------------------------------------------------------------------------
;Name: introduction
;
;Description: Introduces program title, programmer name, and a description of the program details
;
;Preconditions: intro_1 must be initialized as a string
;
;Postconditions: None
;
;Receives: [ebp+8] = intro_1
;
;Returns: EDX holds intro_1 string following display
;----------------------------------------------------------------------------------------
introduction PROC

	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8]
	call	WriteString
	pop		ebp
	RET		4

introduction ENDP


;----------------------------------------------------------------------------------------
;Name: fillArray
;
;Description: Fills randArray with random integers within the range of LO and HI constants
;				for the length of ARRAYSIZE
;				
;
;Preconditions: randArray must be empty and initialized to ARRAYSIZE; constants ARRAYSIZE, LO, 
;				and HI must be set; RANDOMIZE must be called prior to fillArray for array to 
;				have different sets of integers for each each
;
;Postconditions: changes registers ecx, edi, eax
;
;Receives:	ARRAYSIZE = constant variable
;			LO = constant variable
;			[ebp+8] = upper_bound
;			[ebp+12] = randArray
;
;Returns: randArray complete with random integers within the range of LO and HI for length of ARRAYSIZE 
;----------------------------------------------------------------------------------------
fillArray PROC
	
	push	ebp
	mov		ebp, esp
	mov		ecx, ARRAYSIZE
	mov		edi, [ebp+12]		; address of empty randArray in edi

_fillLoop:
	mov		eax, [ebp+8]
	call	RandomRange
	add		eax, LO				; adds LO constant to random integer to maintain range integrity
	mov		[edi], eax
	add		edi, 4
	LOOP	_fillLoop

	pop		ebp
	ret		8

fillArray ENDP


;----------------------------------------------------------------------------------------
;Name: sortList
;
;Description: This procedure takes randArray and sorts its values in ascending order. 
;				May call ExchangeElements procedure when needed
;
;Preconditions: randArray must be initialized with integers
;
;Postconditions: changes registers edi, ebx, ecx, eax, edx
;
;Receives: [ebp+8] = randArray
;
;Returns: Returns a randArray with integers sorted into ascending order
;----------------------------------------------------------------------------------------
sortList PROC

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+8]		; loads array into edi
	mov		ebx, edi			; EBX holds the address of the first value of the array
	add		edi, 4				
	mov		ecx, ARRAYSIZE		; set loop counter
	dec		ecx					; minus 1 because we will begin at the 2nd value


_saveEDI:
	push	edi					; save EDI for outerloop
	mov		eax, [edi]			; EAX holds current value

	_sortLoop:
		CMP		edi, ebx
		JE		_restartSort
		mov		edx, [edi-4]
		CMP		eax, edx		
		JL		_exchange
		JGE		_continueIteration

	_continueIteration:
	sub		edi, 4
	JMP		_sortLoop

	_exchange:
	push	eax
	push	edx
	call	exchangeElements
	JMP		_continueIteration

_restartSort:
	pop		edi
	add		edi, 4
	LOOP	_saveEDI
	JMP		_endProc

_endProc:
	pop		ebp
	ret		4


sortList ENDP


;----------------------------------------------------------------------------------------
;Name: exchangeElements
;
;Description: Nested within the sortList procedure, exchangeElements is called when two integers
;				are identified for exchanging to reach ascending order
;
;Preconditions: randArray must have integers filled within array; sortList procedure must be called prior
;
;Postconditions: the two parameters for procedure will have exchanged indices in randArray; 
;					all registers restored at end of procedure
;
;Receives: eax register which holds value 1 and edx which holds value 2
;
;Returns: randArray with updated changes to reflect value exchange
;----------------------------------------------------------------------------------------
exchangeElements PROC

	push	ebp
	mov		ebp, esp
	; save registers
	push	edx
	push	eax
	push	ebx				
	push	edi				
	;exchange values
	sub		edi, 4
	mov		[edi], eax
	add		edi, 4
	mov		[edi], edx		; placing greater value in new spot
	; restore registers
	pop		edi
	pop		ebx
	pop		eax
	pop		edx

	pop		ebp
	ret		8


exchangeElements ENDP


;----------------------------------------------------------------------------------------
;Name: displayMedian
;
;Description: This procedure calculates the median value of the sorted randArray, rounding up
;				as needed
;
;Preconditions: randArray must be sorted following the sortList procedure, filled with integers
;				ARRAYSIZE constant must be initialized; type_arr must hold the TYPE of value in randArray
;				med_text must hold a string
;
;Postconditions: changes registers edi, eax, edx, ebx, ecx
;
;Receives:	ARRAYSIZE = constant
;			[ebp+8] = randArray
;			[ebp+12] = med_text (median title)
;			[ebp+16] = type_arr
;
;Returns: displays median on screen
;----------------------------------------------------------------------------------------
displayMedian PROC

	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+8]	; loads array into edi

	; display title
	mov		edx, [ebp+12]	
	call	WriteString

	; finds median index of array   
	mov		eax, ARRAYSIZE
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	JE		_evensize
	JMP		_oddsize

_evensize:
	dec		eax				
	mov		ebx, [ebp+16]
	mul		ebx				; eax now holds the number of bytes to increase edi by to reach the median index
	add		edi, eax
	mov		eax, [edi]		; eax holds the first median index
	add		edi, [ebp+16]
	mov		ebx, [edi]		; ebx holds the second median index
	add		eax, ebx	
	mov		ebx, 2
	mov		edx, 0
	div		ebx				
	mov		ecx, eax		; ecx holds the current median
	; identify if rounding is needed
	mov		eax, edx		; move remainder to eax
	mov		ebx, 10
	mul		ebx
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	; if .5 or greater, roundUp
	cmp		eax, 5
	JAE		_roundUp
	JMP		_doNotRound

_roundUp:
	mov		eax, ecx
	inc		eax
	call	WriteDec
	call	Crlf
	call	Crlf
	JMP		_endProc

_doNotRound:
	mov		eax, ecx
	call	WriteDec
	call	Crlf
	call	Crlf
	JMP		_endProc

_oddsize:
	mov		ebx, [ebp+16]
	mul		ebx			
	add		edi, eax
	mov		eax, [edi]		; eax holds the median index
	call	WriteDec
	call	Crlf
	call	Crlf
	JMP		_endProc

_endProc:
	pop		ebp
	ret		20


displayMedian ENDP


;----------------------------------------------------------------------------------------
;Name: displayList
;
;Description: Displays provided array with spaces in between each number and 20 numbers to a line
;
;Preconditions: space and title of array must be initialized as strings, array must be filled with integers
;				lenArray must be accurate to the length of pushed array, lineCount must be initialized
;				to desired number of integers shown per line (20)
;
;Postconditions: changes registers esi, ebx, ecx, eax
;
;Receives:	[ebp+8] = lineCount
;			[ebp+12] = space
;			[ebp+16] = lenArray
;			[ebp+20] = array
;			[ebp+24] = title
;
;Returns: Displays title of array and array on screen 
;----------------------------------------------------------------------------------------
displayList PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+20]	; ESI holds array
	mov		ebx, [ebp+8]	; EBX holds lineCount

	; display title
	mov		edx, [ebp+24]	; EDX holds title
	call	WriteString

	; set Loop
	mov		ecx, [ebp+16]	

_displayLoop:
	mov		eax, [esi]
	call	WriteDec
	mov		edx, [ebp+12]
	call	WriteString
	add		esi, 4
	dec		ebx
	CMP		ebx, 0
	JE		_newLine

_continueLoop:
	LOOP	_displayLoop
	call	Crlf
	call	Crlf
	JMP		_endProc

_newLine:
	call	CrlF
	mov		ebx, [ebp+8]
	JMP		_continueLoop

_endProc:
	pop		ebp
	ret		20

displayList ENDP


;----------------------------------------------------------------------------------------
;Name: countList
;
;Description: Fills countArray with the frequency of each integer within the given range
;				based off of randArray contents
;
;Preconditions: randArray must be filled with integers and sorted in ascending order; 
;				countArray must be empty
;
;Postconditions: changes registers esi, edi, ecx, eax, ebx; changes contents of countArray
;
;Receives:	[ebp+8] = randArray
;			[ebp+12] = countArray
;
;Returns: changes contents of countArray to reflect frequency of each number within given range
;----------------------------------------------------------------------------------------
countList PROC

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]		; esi holds randArray
	mov		edi, [ebp+8]		; edi holds countArray

	; initialize registers
	mov		ecx, ARRAYSIZE		; loop is HI - LO
	mov		eax, 0			; eax will hold current count
	mov		ebx, LO			; ebx will hold current number

_countLoop:
	; comparing array value with current value
	cmp		ebx, [esi]
	JE		_addCount
	JNE		_newNum

_addCount:
	inc		eax
	add		esi, 4
	LOOP	_countLoop
	mov		[edi], eax
	cmp		ebx, HI
	; if final number in randArray is not the upper range
	JNE		_completeCount
	JMP		_endProc

_newNum:
	mov		[edi], eax
	mov		eax, 0
	inc		ebx
	add		edi, 4
	JMP		_countLoop

; intialize remaining range values to 0 to complete array
_completeCount:
	mov		ecx, HI
	sub		ecx, ebx		; identify how many numbers are left
	mov		eax, 0

_zeroLoop:
	add		edi, 4
	mov		[edi], eax
	LOOP	_zeroLoop
	JMP		_endProc

_endProc:
	pop		ebp
	ret		8


countList ENDP


;----------------------------------------------------------------------------------------
;Name: farewell
;
;Description: Displays farewell message before program ends
;
;Preconditions: goodbye must be initialized to a string value
;
;Postconditions: changes register edx
;
;Receives: [ebp+8] = goodbye
;
;Returns: Displays farewell message
;----------------------------------------------------------------------------------------
farewell PROC

	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8]
	call	WriteString
	call	Crlf
	pop		ebp
	RET		4


farewell ENDP



END main
