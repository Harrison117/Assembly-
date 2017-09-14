
; if a > b AND a < 9 : print a
; print "End of Program"
; ...END

section .data

  prompt db 'End of Program', 10
  promptLen equ $-prompt

  grt db 'a > b', 10
  grtLen equ $-grt

  a db 1
  b db 2

section .txt
  global _start

_start:

  mov al, [a]           ; Since 'cmp a, b' is invalid, move a value to a proper register

  cmp al, [b]           ; also means 'cmp a, b' (compare a and b)
  jbe next              ; if a <= b, jump to 'next' label

second_cond:
  cmp byte[a], 99       ; if a(value in al) is GREATER THAN (ja - jABOVE) b, go to 'greater'
  jae next              ; if a >= 9, jump to 'next' label
; IF NONE OF THE CONDITIONS ARE MET (DIDN'T JUMP TO NEXT), THEN IT MEANS
;  THAT 'a > b AND a < 99' (Proceed to printing variable 'a')

print_a:
  add byte[a], '0'
  mov eax, 4
  mov ebx, 1
  mov ecx, a    ; prints the value of variable 'a'
  mov edx, 1
  int 80h

next:
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt    ; prints 'End of Program'
  mov edx, promptLen
  int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h
