
; if a > b: print "a > b"
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

  mov al, [a]       ; Since 'cmp a, b' is invalid, move a value to a proper register

  cmp al, [b]       ; also means 'cmp a, b'

  ja greater        ; if a(value in al) is GREATER THAN (ja - jABOVE) b, go to 'greater'
  jmp next          ; force jump to 'next' label

greater:
  mov eax, 4
  mov ebx, 1
  mov ecx, grt      ; prints 'a > b'
  mov edx, grtLen
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
