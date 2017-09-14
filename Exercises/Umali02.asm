
; @author Harold Umali
;
; Ask the user for two inputs; weight and height, then determine
;   the BMI value and category
;
; CATEGORIES:
; Underweight 	    BMI <	18
; Normal 	          18 <= BMI <	25
; Overweight 	      25 <= BMI <	30
; obese_Condition   BMI > 30

section .data

  weightPrompt db 'Enter your Weight: '
  weightPromptLength equ $-weightPrompt

  heightPrompt db 'Enter your Height: '
  heightPromptLength equ $-heightPrompt

  BMIPrompt db 'BMI: '
  BMIPromptLength equ $-BMIPrompt

  categoryPrompt db 'Category: '
  categoryPromptLength equ $-categoryPrompt

  underweightPrompt db 'Underweight', 10
  underweightPromptLength equ $-underweightPrompt

  normalWeightPrompt db 'Normal', 10
  normalWeightPromptLength equ $-normalWeightPrompt

  overweightPrompt db 'Overweight', 10
  overweightPromptLength equ $-overweightPrompt

  obesePrompt db 'obese_Condition', 10
  obesePromptLength equ $-obesePrompt

  newLine db 10

section .bss

  weightInTens resb 1
  weightInOnes resb 1

  heightNumber resb 1

  resultingBMI resb 2

  bmiInTens resb 1
  bmiInOnes resb 1

  newLineCatcher resb 1

section .txt
  global _start

_start:

; ENTER WEIGHT (2-DIGITS)
  mov eax, 4
  mov ebx, 1
  mov ecx, weightPrompt
  mov edx, weightPromptLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, weightInTens
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, weightInOnes
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

; ENTER HEIGHT (1-DIGIT)
  mov eax, 4
  mov ebx, 1
  mov ecx, heightPrompt
  mov edx, heightPromptLength
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, heightNumber
  mov edx, 1
  int 80h

  mov eax, 3
  mov ebx, 0
  mov ecx, newLineCatcher
  mov edx, 1
  int 80h

;CONVERT INPUTS INTO INTEGERS
  sub byte[weightInTens], '0'
  sub byte[weightInOnes], '0'

  sub byte[heightNumber], '0'

; EXPAND THE TENS DIGIT...
  mov al, 10
  mul byte[weightInTens]
  ;al = [weightInTens]

; ...AND ADD TO THE ONES DIGIT
; 'weightInOnes' is holding the whole number weight
  add byte[weightInOnes], al

;SQUARE THE HEIGHT
  mov al, [heightNumber]
  mul byte[heightNumber]
  mov byte[heightNumber], al

;DIVIDE WEIGHT TO HEIGHT^2
  mov ah, 0
  mov al, [weightInOnes]
  mov cl, [heightNumber]
  div cl

;ASSIGN TO 'resultingBMI' VAR
  mov ah, 0
  mov byte[resultingBMI], al

;CHECK BMI CATEGORY
; IF BMI < 18
  cmp byte[resultingBMI], 18
  jb underNormal_Condition       ; IF BMI < 18
  jmp condition1           ; ELSE IF BMI >= 18

; ELSE IF BMI >= 18
condition1:
  cmp byte[resultingBMI], 25
  jb normal_Condition             ; IF (BMI >= 8 AND) BMI < 25
  jmp condition2           ; ELSE IF BMI >= 25

; ELSE IF BMI >= 25
condition2:
  cmp byte[resultingBMI], 30
  jb overNormal_Condition        ; IF BMI < 30
  jmp obese_Condition           ; ELSE IF BMI >= 30

underNormal_Condition:
  mov eax,4
  mov ebx,1
  mov ecx, underweightPrompt
  mov edx, underweightPromptLength
  int 80h
  jmp main

normal_Condition:
  mov eax,4
  mov ebx,1
  mov ecx, normalWeightPrompt
  mov edx, normalWeightPromptLength
  int 80h
  jmp main

overNormal_Condition:
  mov eax,4
  mov ebx,1
  mov ecx, overweightPrompt
  mov edx, overweightPromptLength
  int 80h
  jmp main

obese_Condition:
  mov eax,4
  mov ebx,1
  mov ecx, obesePrompt
  mov edx, obesePromptLength
  int 80h

main:

;CONVERT NUMERICAL BMI INTO PRINTABLE BMI

;EXPAND THE 2-DIGIT BMI NUMBER
  mov ah, 0
  mov al, [resultingBMI]
  mov cl, 10
  div cl
  mov byte[bmiInTens], al
  mov byte[bmiInOnes], ah

;CONVERT NUMBER INTO CHARACTERS
  add byte[bmiInTens], '0'
  add byte[bmiInOnes], '0'

  mov eax,4
  mov ebx,1
  mov ecx, BMIPrompt
  mov edx, BMIPromptLength
  int 80h

  mov eax,4
  mov ebx,1
  mov ecx, bmiInTens
  mov edx, 1
  int 80h

  mov eax,4
  mov ebx,1
  mov ecx, bmiInOnes
  mov edx, 1
  int 80h

  mov eax,4
  mov ebx,1
  mov ecx, newLine
  mov edx, 1
  int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h
