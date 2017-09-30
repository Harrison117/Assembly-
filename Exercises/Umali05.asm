;
;   @author: Harold Umali
;   @date-created: September 27 2017
;   @date-finished:
;   @description: Given an input N from user, get prime numbers from 1 up to N
;    (not to be confused with getting N prime numbers) using 'loops' and subroutines
;

section .data
	promptMessage db 'Print Prime numbers up to: '
	promptMessageLength equ $-promptMessage

	resultMessage db 'The Prime numbers are:'
	resultMessageLength equ $-resultMessage

	noneMessage db 'None...'
	noneMessageLength equ $-noneMessage

	testMSG db 'TEST!'
	testMSGLength equ $-testMSG

	space db ' '
	spaceLength equ $-space

	newLine db 10

section .bss

	userInputTens resb 1
	userInputOnes resb 1

	userInput resb 1

	testNumber resb 1

	index resb 1
	numberOfFactors resb 1

	newLineCatcher resb 1

section .txt
	global _start

_start:
	mov 	eax, 	4
	mov 	ebx, 	1
	mov		ecx, 	promptMessage
	mov 	edx, 	promptMessageLength
	int 	80h

	mov 	eax, 	3
	mov 	ebx, 	0
	mov 	ecx, 	userInputTens
	mov 	edx, 	1
	int 	80h

	mov 	eax, 	3
	mov 	ebx, 	0
	mov 	ecx, 	userInputOnes
	mov 	edx, 	1
	int 	80h

	mov 	eax, 	3
	mov 	ebx, 	0
	mov 	ecx, 	newLineCatcher
	mov 	edx, 	1
	int 	80h

	convertCharIntoInt:
		sub 	byte[userInputTens],	'0'
		sub 	byte[userInputOnes],	'0'

	combineInt:
		mov 	al, 	10
		mul 				byte[userInputTens]
		add 	al, 	byte[userInputOnes]

		mov 	byte[userInput], 	al

	checkInput:
		cmp 	byte[userInput], 	1
		jbe 			printNoPrime					; BASE CASE: if input number is 1 or below

		mov 	byte[testNumber], 2				; INITIALIZATION: starts the test number from 2

	mainLoop:
		mov 	al,	[testNumber]

		cmp 	al, [userInput]						; CONDITION: if the testNumber <= userInput
		jnbe 			mainLoopEnd						; end the loop if testNumber > userInput

																		; getPrimeNumbers(testNumber) subroutine call
		push 			word[testNumber]			; pass the testNumber as a parameter of a function
		call 			getPrimeNumbers				; push Program Counter to stack then perform the subroutine

		inc 			byte[testNumber]			; UPDATE: update the testNumber

		jmp 			mainLoop							; LOOP
	mainLoopEnd:
		mov 	eax, 	4
		mov 	ebx, 	1
		mov 	ecx, 	newLine
		mov 	edx, 	1
		int 	80h
		jmp 	terminate

	printNoPrime:
		mov 	eax, 	4
		mov 	ebx, 	1
		mov 	ecx, 	noneMessage
		mov 	edx, 	noneMessageLength
		int 	80h

		mov 	eax, 	4
		mov 	ebx, 	1
		mov 	ecx, 	newLine
		mov 	edx, 	1
		int 	80h

	terminate:
	  mov 	eax, 	1
	  mov 	ebx, 	0
	  int 	80h

getPrimeNumbers:
	mov 	ebp, 	esp									; establish placeholder, base pointer, of the stack

																	; add local variables
	sub 	esp, 	2										; INDEX, [ebp - 2]
	sub 	esp, 	2										; numberOfFactors, [ebp - 4]

	mov 	word[ebp - 2], 	1					; INITIALIZATION: initialize INDEX
	mov 	word[ebp - 4], 	0					; INITIALIZATION: initialize numberOfFactors

	checkingLoop:
		mov 	ax, 	[ebp - 2]

		cmp 	ax, 	[ebp + 4]					; CONDITION: if index <= testNumber
		jnbe 	checkingLoopEnd

		mov 	dx, 0
		mov 	ax, [ebp + 4]
		div 	word[ebp - 2]
		cmp 	dx, 0

		jne 			incIndex
		inc 			word[ebp - 4]

	incIndex:
		inc 			word[ebp - 2]
		jmp 			checkingLoop
	checkingLoopEnd:

	toPrint:
		cmp 			word[ebp - 4], 	2		; a prime number only has two factors
																	; if the number of factors exceed 2, its not a prime
		jnbe 			returnToMain

		call 	printPrime							; printPrime() function call

	returnToMain:
		add 	esp, 4									; removes the local variables INDEX and numberOfFactors

	ret 	2													; popping the Program counter, removing the parameter
																	; passed and ends the subroutine

printPrime:

	sub 	esp, 2										; ONES, [ebp - 10]
	sub 	esp, 2										; TENS, [ebp - 12]

	mov 	ax, 	[ebp + 4]
	mov 	cx, 	10
	div 	cx

	mov 	[ebp - 12], 	ax
	mov 	[ebp - 10], 	dx

	cmp 	word[ebp - 12], 	0
	je 		printOnes

	printTens:
		add 	word[ebp - 12], 	'0'

		mov 	eax, 	4
		mov 	ebx, 	1
		lea 	ecx, 	[ebp - 12]
		mov 	edx, 	1
		int 	80h

	printOnes:
		add 	word[ebp - 10], 	'0'

		mov 	eax, 	4
		mov 	ebx, 	1
		lea 	ecx, 	[ebp - 10]
		mov 	edx, 	1
		int 	80h

		mov 	eax, 	4
		mov 	ebx, 	1
		mov 	ecx, 	space
		mov 	edx, 	spaceLength
		int 	80h

	clearLocalVariables:
		add esp, 4

	endFunction:
		ret
