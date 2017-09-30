;
;   @author: Harold Umali
;   @date-created: September 27 2017
;   @description: basic pass-by-value procedure that adds two numbers, x and y
;				using subroutine concept in assembly
;
;		pseudocode:
;			void sum(int x, int y){
;				int sum = x + y;
;				print(sum);
;			}
;
;			sum(3,4);		// expected value: 7
;
;		to compile asm programs with sub-routines:
;				nasm -f elf <filename>.asm
;				ld -m i386 -o <target> <filename>.o
;				./<target>
;

section .data
	firstNumber db 3
	secondNumber db 4
	newline db 10

section .text
	global _start

_start:

; the stack initially:
;  ___
;	|	  |
; |___|
;	|   |
; |___|
;	|	  |
; |___|
;	|	  |
; |___| /__ esp
;				\

	; pushing into the stack should be in at least word-sized operation
	push word[firstNumber]
	; the stack should look like:
	;  ___
	;	|	  |
	; |___|
	;	|   |
	; |___|
	;	|	  |
	; |___| /__ esp
	;	|	x | \
	; |___|
	;

	push word[secondNumber]
	; the stack should look like:
	;  ___
	;	|	  |
	; |___|
	;	|   |
	; |___| /__ esp
	;	|	y | \
	; |___|
	;	|	x |
	; |___|
	;

	call sum
	; what happened in 'call sum':
	;	push PC			; PC - Program Counter/address of the next instruction
	; jmp sum
	; the stack should like:
	;  ___
	;	|	  |
	; |___| /__ esp
	;	|PC | \
	; |___|
	;	|	y |
	; |___|
	;	|	x |
	; |___|

terminate:
	mov eax, 1
	mov ebx, 0
	int 80h

;################################################################
;	Subroutines comes after the main subroutine, '_start'
;################################################################

sum:
	mov ebp, esp				; assign to the base pointer the address of a dynamic stack
											; pointer as a point of reference...

	; the stack should like:
	;  ___
	;	|   |
	; |___| /__ esp,ebp
	;	|PC | \
	; |___|
	;	|	y |
	; |___|
	;	|	x |
	; |___|

	sub esp, 2					; create a two-byte local variable in the stack;
											;	in turn moves (no pun intended) the stack pointer to the local var
	; the stack should like:
	;  _____  /__esp
	;	|temp | \
	; |_____| /__ ebp
	;	| PC  | \
	; |_____|
	;	|	 y  |
	; |_____|
	;	|	 x  |
	; |_____|

	; sum = x + y
	; [ebp - 2] = [ebp + 6] + [ebp + 4]
	mov ax, [ebp + 6]
	add ax, [ebp + 4]
	mov [ebp - 2], ax

	; CONVERT FOR PRINTING
	add word[ebp - 2], '0'

	; PRINT THE RESULT
	mov eax, 4
	mov ebx, 1
	lea ecx, [ebp - 2]	; 'lea' instruction means 'load effective address
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

	add esp, 2					; remove the local variable, [ebp - 2] in the stack
	; the stack should like:
	;  ___
	;	|   |
	; |___| /__ esp, ebp
	;	|PC | \
	; |___|
	;	|	y |
	; |___|
	;	|	x |
	; |___|
	;

	ret 4								; clears the stack by the total number of bytes remaining inside
	; the stack should like:
	;  ___
	;	|   |
	; |___| /__ ebp
	;	|   | \
	; |___|
	;	|	  |
	; |___|
	;	|	  |
	; |___| /__ esp
	;				\
