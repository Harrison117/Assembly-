section .data
	prompt db 'Enter a number: '

	promptLen equ $-prompt

section .bss

	numTens1 resb 1
	numOnes1 resb 1

	numTens2 resb 1
	numOnes2 resb 1

section .txt
	global _start

_start:

;FIRST NUMBER
	; prints the prompt message
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptLen
	int 80h

	;INPUT IS EXPECTED TO TWO DIGIT

	; ask for a number input
	; note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, numTens1
	mov edx, 1;---------------------------------------------gets the first char from the input
	int 80h

	; ask for a number input
	; note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, numOnes1
	mov edx, 2;---------------------------------------------gets the rest of the input
	int 80h

; converts the two CHAR VALUES into NUMBER VALUES
sub byte[numTens1], '0'
sub byte[numOnes1], '0'

; make a two digit number (I know, right....)
; elementary addition...

; multiply the tens digit to 10,...
mov al, 10
mul byte[numTens1]
; ...then add it to one
add byte[numOnes1], al
; AT THIS POINT THERE IS A TWO-DIGIT NUMBER STORED IN 'numOnes1'


;FIRST NUMBER END

;SECOND NUMBER
	; prints the prompt message
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptLen
	int 80h

	; ask for a number input
	; note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, numTens2
	mov edx, 1;---------------------------------------------gets the first char from the input
	int 80h

	; ask for a number input
	; note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, numOnes2
	mov edx, 2;---------------------------------------------gets the rest of the input
	int 80h

	; converts the two CHAR VALUES into NUMBER VALUES
	sub byte[numTens2], '0'
	sub byte[numOnes2], '0'

	; make a two digit number (I know, right....)
	; elementary addition...

	; multiply the tens digit to 10,...
	mov al, 10
	mul byte[numTens2]
	; ...then add it to one
	add byte[numOnes2], al
	; AT THIS POINT THERE IS A TWO-DIGIT NUMBER STORED IN 'numOnes2'

;SECOND NUMBER END

;ADDING THE INPUT (TWO DIGITS)

	; initialize the register contents...
	mov al, [numOnes1]
	; ...then add the TWO-DIGIT numbers
	add byte[numOnes2], al

	; initialize the registers for division
	mov ah, 0
	mov al, [numOnes2]
	; divide. Put the divisor in another 8-bit register
	mov cl, 10
	div cl
	;  REMEMBER: 'div <src>' is '<a 8-bit register> divided by <src>'
	;  al register stores the quotient and ah register stores the remainder

	; reuse the old variables. al (quotient) goes to the tens variable and ah to the ones variable
	mov byte[numTens1], al
	mov byte[numOnes1], ah


	;convert the result from NUMBER VALUES to CHAR VALUES
	;  since the result will be printed
	add byte[numTens1], '0'
	add byte[numOnes1], '0'

	; prints the tens digit
	mov eax, 4
	mov ebx, 1
	mov ecx, numTens1
	mov edx, 1
	int 80h

	; prints the tens digit
	mov eax, 4
	mov ebx, 1
	mov ecx, numOnes1
	mov edx, 2
	int 80h

;ADDING END

	;TERMINATE
	mov eax, 1
	mov ebx, 0
	int 80h
