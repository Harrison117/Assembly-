;
;   @author: Harold Umali
;   @date-created: September 20 2017
;   @date-finished: September 20 2017
;   @description: given input m and n, print index from 1 to n that is divisible by m
;     using 'loop' concept (by using conditional jumps)
;
;   Psuedocode:
;   for index=1, index < n, increment i:
;       tempNum = index % m
;       if tempNum == 0:
;           print index
;       end-if
;   end-for-loop
;

section .data
	prompt db 'Enter a number, n: '
  promptLen equ $-prompt

  promptDivisor db 'Enter a number, m: '
  promptDivisorLength equ $-promptDivisor

  index db 1                ; INDEX IS ALREADY INITIALIZED HERE

  space db ' '
  spaceLength equ $-space

section .bss

	numTens resb 1
	numOnes resb 1

	divisibleNumTens resb 1
	divisibleNumOnes resb 1

  tempNum resb 1

  newLine resb 1

section .txt
	global _start

_start:

firstInput:
	mov eax, 4
	mov ebx, 1
	mov ecx, prompt
	mov edx, promptLen
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, numTens
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, numOnes
	mov edx, 1
	int 80h

  mov eax, 3
	mov ebx, 0
	mov ecx, newLine
	mov edx, 1
	int 80h

sub byte[numTens], '0'
sub byte[numOnes], '0'

mov al, 10
mul byte[numTens]
add byte[numOnes], al


;FIRST NUMBER END

secondInput:
	mov eax, 4
	mov ebx, 1
	mov ecx, promptDivisor
	mov edx, promptDivisorLength
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, divisibleNumTens
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, divisibleNumOnes
	mov edx, 1
	int 80h

  mov eax, 3
	mov ebx, 0
	mov ecx, newLine
	mov edx, 1
	int 80h

	; converts the two CHAR VALUES into NUMBER VALUES
	sub byte[divisibleNumTens], '0'
	sub byte[divisibleNumOnes], '0'

	mov al, 10
	mul byte[divisibleNumTens]
	add byte[divisibleNumOnes], al

  cmp byte[divisibleNumOnes], 0
  je terminate            ; ends the program if the divisor is 0
                          ; else, continue...

;SECOND NUMBER END

loopBody:
  mov dl, [index]         ; INITIALIZE 'index'
  cmp dl, [numOnes]       ; CONDITION (if index<userInputFactor)
  jnbe loopEnd

  mov ah, 0               ; clear ah
  mov al, [index]
  div byte[divisibleNumOnes]
  mov byte[tempNum], ah

  mov al, [index]         ; hold index in al for comparison
  inc byte[index]         ; INCREMENT

  cmp byte[tempNum], 0    ; if remainder == 0
  jne loopBody            ; if not then loop

  mov byte[tempNum], al   ; else, move the index to the temporary variable

  cmp byte[tempNum], 10   ; check if index > 10
  mov byte[numTens], 0    ; initialize the tens number incase the index >= 10
  jb convertIntToChar     ; immediately convert the index to char for printing

separateTerms:  ; STILL PART OF THE LOOP
  mov ah, 0
  mov al, [tempNum]
  mov cl, 10
  div cl

  mov byte[numTens], al
  mov byte[tempNum], ah

convertIntToChar:  ; STILL PART OF THE LOOP
  add byte[numTens], '0'
  add byte[tempNum], '0'

printNumber:  ; STILL PART OF THE LOOP
  mov eax, 4
  mov ebx, 1
  mov ecx, numTens
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, tempNum
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, space
  mov edx, spaceLength
  int 80h

  jmp loopBody
loopEnd:
  mov eax, 4
  mov ebx, 1
  mov ecx, newLine
  mov edx, 1
  int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h
