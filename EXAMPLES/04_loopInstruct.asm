;
;   @author: Harold Umali (with Guidance from Ma'am Kedall Jeane Jaen)
;   @date-created: September 20 2017
;   @description: gets the summation of numbers 1 to N (in this example, n equals 9)
;				using 'loop' logic (un/conditional jumps and concept of loops in high level PLs)
;
;       ! USES DO-WHILE LOOP CONCEPT BY USING THE LOOP INSTRUCTION !
;
;       NOTE!!! the loop instruction uses decrement as a form of updating. Most
;         implementations may or may not use the loop instruction
;

section .data
  sum db 0
	N db 9

	newLine db 10

section .bss
  i resb 1

section .text
  global _start

_start:

mov ecx, [N]				; INITIALIZATION of 'loop'

loopBody:
  add byte[sum], cl

  loop loopBody     ; this statement does:
  ; dec ecx         ; UPDATE (DECREMENT) of the 'loop'
  ; cmp ecx, 0      ; CONDITION checking of the 'loop'
  ; jne loopBody    ; 'loop' back to the label 'loopBody' if ecx != 0


loopEnd:

separationOfTwoDigits:
	mov ah, 0
	mov al, [sum]
	mov bl, 10
	div bl

	mov byte[i], al			; TENS
	mov byte[sum], ah		; ONES

convertIntToChar:
	add byte[i], '0'
	add byte[sum], '0'

printSum:
	mov eax, 4
	mov ebx, 1
	mov ecx, i
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, sum
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newLine
	mov edx, 1
	int 80h

terminate:
	mov eax, 1
	mov ebx, 0
	int 80h
