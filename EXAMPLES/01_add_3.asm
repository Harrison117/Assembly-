section .data

	prompt db 'Enter 3-digit number: '
	promptLen equ $-prompt

	printAns db 'Quotient: '
	ansLen equ $-printAns
	printRem db 'Remainder: '
	remLen equ $-printRem

	newLine db 10

section .bss

	temp1 resb 4
	temp2 resb 4

	numHundreds1 resb 1
	numTens1 resb 1
	numOnes1 resb 1

	numHundreds2 resb 1
	numTens2 resb 1
	numOnes2 resb 1

	rem resb 1
	quo resb 1

section .txt
	global _start
_start:

;FIRST NUMBER

;PRINT PROMPT
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptLen
	int 80h

;GETS THE FIRST DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numHundreds1
	mov edx, 1
	int 80h

;GETS THE SECOND DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numTens1
	mov edx, 1
	int 80h

;GETS THE THIRD DIGIT AND THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, numOnes1
	mov edx, 2
	int 80h

;CONVERTS THE SEPARATE INPUTS INTO NUMBERS
	sub byte[numHundreds1], '0'
	sub byte[numTens1], '0'
	sub byte[numOnes1], '0'

;CONVERT INTO HUNDREDS
	mov al, 100
	mul byte[numHundreds1]
	mov byte[temp1], al

;CONVERT INTO TENS THEN ADD TO HUNDREDS
	mov al, 10
	mul byte[numTens1]
	add byte[temp1], al

;CONVERT INTO ONES THE ADD THE TOTAL
	mov al, [numOnes1]
	add byte[temp1], al

;FIRST NUMBER END

;SECOND NUMBER

;PRINT PROMPT
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptLen
	int 80h

;GETS THE FIRST DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numHundreds2
	mov edx, 1
	int 80h

;GETS THE SECOND DIGIT
	mov eax, 3
	mov ebx, 0
	mov ecx, numTens2
	mov edx, 1
	int 80h

;GETS THE THIRD DIGIT AND THE NEW LINE
	mov eax, 3
	mov ebx, 0
	mov ecx, numOnes2
	mov edx, 2
	int 80h

	sub byte[numHundreds2], '0'
	sub byte[numTens2], '0'
	sub byte[numOnes2], '0'

	mov al, 100
	mul byte[numHundreds2]
	mov byte[temp2], al

	mov al, 10
	mul byte[numTens2]
	add byte[temp2], al

	mov al, [numOnes2]
	add byte[temp2], al

;SECOND NUMBER END

;ADD THE TWO NUMBERS
	mov ax, [temp1]
	add word[temp2], ax

;GET THE AVERAGE OF THE TWO NUMBERS AND THE REMAINDER
	mov dx, 0
	mov ax, [temp2]
	mov cx, 2
	div cx
	mov word[rem], dx
	mov word[temp2], ax

;GET THE HUNDREDS DIGIT
	mov ah, 0
	mov al, [temp2]
	mov cl, 100
	div cl
	mov byte[numHundreds1], al

;GET THE TENS AND ONES DIGIT
	mov byte[temp2], ah
	mov ah, 0
	mov al, [temp2]
	mov cl, 10
	div cl
	mov byte[numTens1], al
	mov byte[numOnes1], ah

;CONVERT THE NUMBERS INTO CHARACTERS FOR PRINTING
	add byte[numHundreds1], '0'
	add byte[numTens1], '0'
	add byte[numOnes1], '0'
	add byte[rem], '0'

;PRINTS THE NUMBERS

	mov eax, 4
	mov ebx, 1
	mov ecx, printAns
	mov edx, ansLen
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numHundreds1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numTens1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, numOnes1
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newLine
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, printRem
	mov edx, remLen
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, rem
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
