
; @author Harold Umali
;
;	Ask the User for two 3-digit number then average the two
;   numbers
;

section .data

	digitPrompt db 'Enter 3-digit number: '
	digitPromptLength equ $-digitPrompt

	promptQuotient db 'Quotient: '
	promptQuotientLength equ $-promptQuotient

	promptRemainder db 'Remainder: '
	promptRemainderLength equ $-promptRemainder

	newLine db 10

section .bss

	newLineCatcher resb 1
	firstNumberHolder resw 1
	secondNumberHolder resw 1

	numberInHundreds1 resw 1
	numberInTens1 resw 1
	numberInOnes1 resw 1

	numberInHundreds2 resw 1
	numberInTens2 resw 1
	numberInOnes2 resw 1

	remainder resb 1

section .txt
	global _start
_start:

;FIRST NUMBER

;PRINT digitPrompt
	mov eax, 4
	mov ebx, 1
	mov ecx, digitPrompt
	mov edx, digitPromptLength
	int 80h

;GETS THE FIRST DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInHundreds1
	mov edx, 1
	int 80h

;GETS THE SECOND DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInTens1
	mov edx, 1
	int 80h

;GETS THE THIRD DIGIT AND THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInOnes1
	mov edx, 1
	int 80h

;CATCH THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, newLineCatcher
	mov edx, 1
	int 80h

;CONVERTS THE SEPARATE INPUTS INTO NUMBERS
	sub word[numberInHundreds1], '0'
	sub word[numberInTens1], '0'
	sub word[numberInOnes1], '0'

;CONVERT INTO HUNDREDS
	mov ax, 100
	mul word[numberInHundreds1]
	mov word[firstNumberHolder], ax

;CONVERT INTO TENS THEN ADD TO HUNDREDS
	mov ax, 10
	mul word[numberInTens1]
	add word[firstNumberHolder], ax

;CONVERT INTO ONES THE ADD THE TOTAL
	mov ax, [numberInOnes1]
	add word[firstNumberHolder], ax

;FIRST NUMBER END

;SECOND NUMBER

;PRINT digitPrompt
	mov eax, 4
	mov ebx, 1
	mov ecx, digitPrompt
	mov edx, digitPromptLength
	int 80h

;GETS THE FIRST DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInHundreds2
	mov edx, 1
	int 80h

;GETS THE SECOND DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInTens2
	mov edx, 1
	int 80h

;GETS THE THIRD DIGIT AND THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, numberInOnes2
	mov edx, 1
	int 80h

;CATCH THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, newLineCatcher
	mov edx, 1
	int 80h

;CONVERT THE INPUTS
	sub word[numberInHundreds2], '0'
	sub word[numberInTens2], '0'
	sub word[numberInOnes2], '0'

	mov ax, 100
	mul word[numberInHundreds2]
	mov word[secondNumberHolder], ax

	mov ax, 10
	mul word[numberInTens2]
	add word[secondNumberHolder], ax

	mov ax, [numberInOnes2]
	add word[secondNumberHolder], ax

;SECOND NUMBER END

;ADD THE TWO NUMBERS
	mov ax, [firstNumberHolder]
	add word[secondNumberHolder], ax

;GET THE AVERAGE OF THE TWO NUMBERS AND THE REMAINDER
	mov dx, 0

	mov ax, [secondNumberHolder]
	mov cx, 2
	div cx
	mov word[remainder], dx
	mov word[secondNumberHolder], ax

;GET THE HUNDREDS DIGIT
	mov dx, 0
	mov ax, [secondNumberHolder]
	mov cx, 100
	div cx
	mov word[numberInHundreds1], ax

;GET THE TENS AND ONES DIGIT
	mov word[secondNumberHolder], dx
	mov dx, 0
	mov ax, [secondNumberHolder]
	mov cx, 10
	div cx
	mov word[numberInTens1], ax
	mov word[numberInOnes1], dx

;CONVERT THE NUMBERS INTO CHARACTERS FOR PRINTING
	add word[numberInHundreds1], '0'
	add word[numberInTens1], '0'
	add word[numberInOnes1], '0'
	add word[remainder], '0'

;PRINTS THE NUMBERS

	mov eax, 4
	mov ebx, 1
	mov ecx, promptQuotient
	mov edx, promptQuotientLength
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numberInHundreds1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numberInTens1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numberInOnes1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newLine
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, promptRemainder
	mov edx, promptRemainderLength
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, remainder
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newLine
	mov edx, 1
	int 80h

;TERMINATE
	mov eax, 1
	mov ebx, 0
	int 80h
