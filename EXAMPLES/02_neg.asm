;
;   @author: Harold Umali (with Guidance from Ma'am Kedall Jeane Jaen)
;   @date-created: August 30 2017
;   @description: subtracts two user-input signed numbers; makes use of signed
;     conditional jumps and negative numbers
;
;   WORKING WITH NEGATIVE NUMBERS:
;     Always consider the variable and operation size for a unsigned and signed
;       number:
;         > 8-bit registers can acommodate 0 to 255(unsigned) OR -127 to 127 (signed)
;

section .data

  promptMessage db 'Enter a number: '
  promptMessageLength equ $-promptMessage

  negativeSign db '-'

section .bss

  firstNumber resb 1
  secondNumber resb 1

;Reserved to check if the number given is positive or negative
  firstSign resb 1
  secondSign resb 1

  newLineCatcher resb 1

section .txt
  global _start

_start:

;FIRST NUMBER
  mov eax, 4
  mov ebx, 1
  mov ecx, promptMessage
  mov edx, promptMessageLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, firstSign
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, firstNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

;SECOND NUMBER
  mov eax, 4
  mov ebx, 1
  mov ecx, promptMessage
  mov edx, promptMessageLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, secondSign
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, secondNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

;CONVERT CHAR INPUT INTO INT
  sub byte[firstNumber], '0'
  sub byte[secondNumber], '0'
;AT THIS POINT, THEY ARE STILL POSITIVE

;SIGNED-NUMBER CHECKER
checkFirstNum:
  cmp byte[firstSign], '-'    ; compare sign character to negative sign if equal
  jne checkSecondNum          ; if not equal, jump to the next signed number checker
  neg byte[firstNumber]       ; if equal(negative sign is given), negate the number

checkSecondNum:
  cmp byte[secondSign], '-'   ; compare sign character to negative sign if equal
  jne subtractOperation       ; if not equal, jump to the subtraction operation
  neg byte[secondNumber]      ; if equal(negative sign is given), negate the number

subtractOperation:
  mov al, [firstNumber]
  sub byte[firstNumber], al

checkSignResult:
  cmp byte[firstNumber], 0    ; compare resulting value to 0
  jge convertIntToChar        ; if the resulting value is positive...
  neg byte[firstNumber]       ; negate number for conversion

;AT THIS POINT, IF NUMBER IS NEGATIVE, WE PRINT THE NEGATIVE SYMBOL...
  mov eax, 4
  mov ebx, 1
  mov ecx, negativeSign
  mov edx, 1
  int 80h

; ...CONVERT NUMBER TO CHARACTER FOR PRINTING...
convertIntToChar:
  add byte[firstNumber], '0'

; ...THEN SIMPLY PRINT THE NUMBER
printResult:
  mov eax, 4
  mov ebx, 1
  mov ecx, firstNumber
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h
