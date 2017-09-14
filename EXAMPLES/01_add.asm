section .data
	prompt1 db 'Enter a number: '

	prompt1Len equ $-prompt1

section .bss

	num1 resb 1
	num2 resb 1

section .txt
	global _start

_start:
	;prints the prompt message
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt1
	mov edx, prompt1Len
	int 80h

	;ask for a number input
	;note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, num1
	mov edx, 2
	int 80h

	;prints the prompt message
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt1
	mov edx, prompt1Len
	int 80h

	;ask for a number input
	;note that the number input is a CHAR LITERAL
	mov eax, 3
	mov ebx, 0
	mov ecx, num2
	mov edx, 2
	int 80h

	;converts the two CHAR VALUES into NUMBER VALUES
	sub byte[num1], '0'
	sub byte[num2], '0'

	;adds the two variables
	;note that adding two variables direclty is invalid
	;  therefore, one variable value must be assign to a 
	;  register then manipulate addition using the register
	;  and a variable
	mov al, [num1]
	add byte[num2], al

	;convert the result from NUMBER VALUES to CHAR VALUES
	;  since the result will be printed
	add byte[num2], '0'

	mov eax, 4
	mov ebx, 1
	mov ecx, num2
	mov edx, 2
	int 80h

	;TERMINATE
	mov eax, 1
	mov ebx, 0
	int 80h
