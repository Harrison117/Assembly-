;
;   @author: Harold Umali
;   @date-created: August 30 2017
;   @date-finished: September 5 2017
;   @description: does the three basic arithmetic operations; makes use of signed
;     conditional jumps and negative numbers
;
;   !!!NOTE!!! WORKING WITH NEGATIVE NUMBERS:
;     Always consider the variable and operation size for a unsigned and signed
;       number:
;         > 8-bit registers can acommodate 0 to 255(unsigned) OR -127 to 127 (signed)
;
section .data

  passed db 'PASSED!', 10
  passedLength equ $-passed

  promptSignedNumberMessage db 'Enter a signed 2-digit number: '
  promptSignedNumberMessageLength equ $-promptSignedNumberMessage

  promptFirstChoice db '[ 1 ] Addition '
  promptFirstChoiceLength equ $-promptFirstChoice

  promptSecondChoice db '[ 2 ] Subtraction '
  promptSecondChoiceLength equ $-promptSecondChoice

  promptThirdChoice db '[ 3 ] Multiplication '
  promptThirdChoiceLength equ $-promptThirdChoice

  promptFourthChoice db '[ 0 ] Exit '
  promptFourthChoiceLength equ $-promptFourthChoice

  promptResult db 'Result: '
  promptResultLength equ $-promptResult

  negativeSign db '-'

  newLine db 10

section .bss

  firstTensNumber resw 1
  firstOnesNumber resw 1

  secondTensNumber resw 1
  secondOnesNumber resw 1

  thousandsResultingNum resb 1
  hundredsResultingNum resb 1
  tensResultingNum resb 1
  onesResultingNum resb 1

  resultingNum resw 1
  resultingSign resb 1

  firstSign resb 1
  secondSign resb 1

  userChoice resb 1

  newLineCatcher resb 1

section .txt
  global _start

_start:

menu:
  mov eax, 4
  mov ebx, 1
  mov ecx, promptFirstChoice
  mov edx, promptFirstChoiceLength
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, promptSecondChoice
  mov edx, promptSecondChoiceLength
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, promptThirdChoice
  mov edx, promptThirdChoiceLength
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, promptFourthChoice
  mov edx, promptFourthChoiceLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, userChoice
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

  sub byte[userChoice], '0'         ; convert user choice into number for evalutation

userDecision1:
  cmp byte[userChoice], 0
  je terminate

inputFirstNumber:
  mov eax, 4
  mov ebx, 1
  mov ecx, promptSignedNumberMessage
  mov edx, promptSignedNumberMessageLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, firstSign
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, firstTensNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, firstOnesNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

inputSecondNumber:
  mov eax, 4
  mov ebx, 1
  mov ecx, promptSignedNumberMessage
  mov edx, promptSignedNumberMessageLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, secondSign
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, secondTensNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, secondOnesNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

;CONVERT CHAR INPUT INTO INT
convertFirstInputToInt:
  sub word[firstTensNumber], '0'
  sub word[firstOnesNumber], '0'
  ;AT THIS POINT, THEY ARE STILL POSITIVE

  mov ax, 10
  mul word[firstTensNumber]       ; product is stored in 'al' register
  add word[firstOnesNumber], ax   ; add the expanded digit to ones
  ;AT THIS POINT, 'firstOnesNumber' HOLDS TWO DIGITS

  cmp byte[firstSign], '-'

  jne convertSecondInputToInt     ; if input is positive, jump to second input conversion

  neg word[firstOnesNumber]       ; else, convert input into negative
  ;FIRST NUMBER END

convertSecondInputToInt:
  sub word[secondTensNumber], '0'
  sub word[secondOnesNumber], '0'
  ;AT THIS POINT, THEY ARE STILL POSITIVE

  mov ax, 10
  mul word[secondTensNumber]        ; product is stored in 'al' register
  add word[secondOnesNumber], ax    ; add the expanded digit to ones
  ;AT THIS POINT, 'secondOnesNumber' HOLDS TWO DIGITS

  cmp byte[secondSign], '-'

  jne userDecision2               ; if input is positive, jump to conditions

  neg word[secondOnesNumber]        ; else, convert input into negative
  ;'convertCharToInt' END
  ;SECOND NUMBER END

userDecision2:
  cmp byte[userChoice], 1           ; 1 = addition operation
  je additionOperation

userDecision3:
  cmp byte[userChoice], 2           ; 2 = subtraction operation
  je subtractionOperation

userDecision4:
  cmp byte[userChoice], 3           ; 3 = multiplication operation
  je multiplicationOperation

additionOperation:
  ; DO WORD SIZE OPERATION IN ADDING
	mov ax, [firstOnesNumber]
  mov word[resultingNum], ax        ; assign the first number to the result

	mov ax, [secondOnesNumber]        ; reuse ax(16bit) register
  add word[resultingNum], ax        ; add the second number to the result

  jmp determineSign                 ; jump to sign determination

subtractionOperation:
  ; DO WORD SIZE OPERATION IN SUBTRACTING
  mov ax, [firstOnesNumber]
  mov word[resultingNum], ax        ; assign the first number to the result

  mov ax, [secondOnesNumber]
  sub word[resultingNum], ax        ; subtract the second number to the result
  jmp determineSign                 ; jump to number determination

multiplicationOperation:
  ; DO WORD SIZE OPERATION IN MULTIPLYING
  mov ax, [firstOnesNumber]
  mul word[secondOnesNumber]
  mov word[resultingNum], ax

determineSign:
  mov byte[resultingSign], '+'        ; initialize the sign

  cmp word[resultingNum], 0           ; compare if the resulting number is (-) or (+)
  jge determineResultingValue         ; if positive, determine the magnitude of value

  ; AT THIS POINT, the resulting sign will be (+) for printing
  je printResult                      ; if it result in 0, straight to conversion for printing

  ; ELSE, THE RESULT IS NEGATIVE
  neg word[resultingNum]              ; negate the number to determine magnitude of value
  mov byte[resultingSign], '-'        ; the resulting si(transferFirstElementToNewList h '())gn will be (-) for printing

determineResultingValue:
  cmp word[resultingNum], 1000         ; compares if it exceeds/preceeds 1000
  jge thousandsNumberSeparation        ; if the input is 1000 or greater

  ;ELSE, RESULT IS LESS THAN 1000
  mov byte[thousandsResultingNum], 0
  cmp word[resultingNum], 100          ; compares if it exceeds/preceeds 100
  jge hundredsNumberSeparation         ; if the input is 100 or greater

  ;ELSE, RESULT IS LESS THAN 100
  mov byte[hundredsResultingNum], 0
  cmp word[resultingNum], 10           ; compares if it exceeds/preceeds 10
  jge tensNumberSeparation             ; if the input is 10 or greater

  mov byte[tensResultingNum], 0
  jl onesNumberSeparation              ; else the input is less than 10

thousandsNumberSeparation:
  mov dx, 0
  mov ax, [resultingNum]
  mov cx, 1000
  div cx
  mov byte[thousandsResultingNum], al
  mov word[resultingNum], dx

  add byte[thousandsResultingNum], '0'  ; convert to char immediately

hundredsNumberSeparation:
  mov dx, 0
  mov ax, [resultingNum]
  mov cx, 100
  div cx
  mov byte[hundredsResultingNum], al
  mov word[resultingNum], dx

  add byte[hundredsResultingNum], '0'   ; convert to char immediately

tensNumberSeparation:
  mov dx, 0
  mov ax, [resultingNum]
  mov cx, 10
  div cx
  mov byte[tensResultingNum], al
  mov word[resultingNum], dx

  add byte[tensResultingNum], '0'       ; convert to char immediately

onesNumberSeparation:
  mov ax, [resultingNum]
  mov byte[onesResultingNum], al

  add byte[onesResultingNum], '0'       ; convert to char immediately

printResult:

  mov eax, 4
  mov ebx, 1
  mov ecx, promptResult
  mov edx, promptResultLength
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, resultingSign
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, thousandsResultingNum
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, hundredsResultingNum
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, tensResultingNum
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, onesResultingNum
  mov edx, 1
  int 80h

  mov eax, 4
  mov ebx, 1
  mov ecx, newLine
  mov edx, 1
  int 80h
;
; PASSED:
;   mov eax, 4
;   mov ebx, 1
;   mov ecx, passed
;   mov edx, passedLength
;   int 80h
;
terminate:
	mov eax, 1
	mov ebx, 0
	int 80h
