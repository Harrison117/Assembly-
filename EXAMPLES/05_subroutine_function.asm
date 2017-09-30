;
;   @author: Harold Umali
;   @date-created: September 27 2017
;   @description: basic pass-by-value procedure that gets the volume of a shape,
;         given length, width and height
;
;		pseudocode:
;			void getVolume(int length, int width, int height){
;				return (l*w*h);
;			}
;

section .data
	givenLength db 5
	givenWidth db 4
	givenHeight db 3
  newline db 10

section .bss
  tensNum resb 1
  onesNum resb 1

section .text
	global _start

_start:

; the stack initially:
;  _______
;	|       |
; |_______|
;	|       |
; |_______|
;	|       |
; |_______|
;	|	      |
; |_______|
;	|	      |
; |_______| /__ esp
;				    \

  sub esp, 2                ; allot space for the return value
  ; the stack should look like:
  ;  _______
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______|
  ;	|	      |
  ; |_______| /__ esp
  ;	| l*w*h | \
  ; |_______|
  ;

  push word[givenLength]
  ; the stack should look like:
  ;  _______
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______| /__ esp
  ;	|	  l   | \
  ; |_______|
  ;	| l*w*h |
  ; |_______|
  ;

  push word[givenWidth]
  ; the stack should look like:
  ;  _______
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______| /__ esp
  ;	|   w   | \
  ; |_______|
  ;	|	  l   |
  ; |_______|
  ;	| l*w*h |
  ; |_______|
  ;

  push word[givenHeight]
  ; the stack should look like:
  ;  _______
  ;	|       |
  ; |_______| /__ esp
  ;	|   h   | \
  ; |_______|
  ;	|   w   |
  ; |_______|
  ;	|	  l   |
  ; |_______|
  ;	| l*w*h |
  ; |_______|
  ;

  call getVolume
  ; the stack should look like:
  ;  _______  /__ esp
  ;	|  PC   | \
  ; |_______|
  ;	|   h   |
  ; |_______|
  ;	|   w   |
  ; |_______|
  ;	|	  l   |
  ; |_______|
  ;	| l*w*h |
  ; |_______|
  ;

  pop ax                    ; gets the return value from the stack
  ; the stack should look like:
  ;  _______
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______|
  ;	|       |
  ; |_______|
  ;	|	      |
  ; |_______|
  ;	|	      |
  ; |_______| /__ esp
  ;				    \

  mov ah, 0
  mov bl, 10
  div bl

  mov byte[tensNum], al     ; TENS
  mov byte[onesNum], ah     ; ONES

  ; CONVERT INT TO CHAR FOR PRINTING
  add byte[tensNum], '0'
  add byte[onesNum], '0'

  mov eax, 4
	mov ebx, 1
	mov ecx, tensNum
	mov edx, 1
	int 80h

  mov eax, 4
	mov ebx, 1
	mov ecx, onesNum
	mov edx, 1
	int 80h

  mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h

getVolume:
  mov ebp, esp
  mov ax, [ebp + 8]
  mul word[ebp + 6]      ; multiply to ax register and assign result to ax register
  mul word[ebp + 4]      ; multiply again to ax
  mov [ebp + 10], ax
  ret 6
