
; if a > b: print "a > b"
; else if a < b: print "a < b"
; else print "a = b"
; print "End of Program"
; ...END

section .data

  prompt db 'End of Program', 10
  promptLen equ $-prompt

  grt db 'a > b', 10
  grtLen equ $-grt

  less db 'a < b', 10
  lessLen equ $-less

  equal db 'a = b', 10
  equalLen equ $-equal

  a db 3
  b db 2

section .txt
  global _start

_start:

  mov al, [a]     ;Since 'cmp a, b' is invalid, move a value to a proper register

  cmp al, [b]     ;also means 'cmp a, b'

  je else         ;else... a = b, jump to 'else'
  ja greater      ;if a > b, jump to 'greater'
  ja lesser       ;if a < b, jump to 'lesser'

greater:
  mov eax, 4
  mov ebx, 1
  mov ecx, grt
  mov edx, grtLen
  int 80h
  jmp next        ;jump to 'next' label
  ; NOTE that if 'jmp <label>' is not present, it will continue sequentially to
  ;   the other labels

lesser:
  mov eax, 4
  mov ebx, 1
  mov ecx, less
  mov edx, lessLen
  int 80h
  jmp next

else:
  mov eax, 4
  mov ebx, 1
  mov ecx, equal
  mov edx, equalLen
  int 80h

next:
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt
  mov edx, promptLen
  int 80h

terminate:
  mov eax, 1
  mov ebx, 0
  int 80h
