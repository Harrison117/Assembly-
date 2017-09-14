section .data			;this section is where the initialized variables are
    
    msg db 'Enter name: '		;assign a string literal to a byte-size variable
					;10 is a new line :3
    
    msgLen equ $-msg			;assign to a CONSTANT (not a variable) the number of characters msg has

section .bss				;this section is where the uninitialized variables are

    name resb 7				;reserve a variable with 7 bytes
    nameLen resb 1			;reserve a variable with 1 byte

section .text				;this is where the program starts
    global _start
_start:

    ;this block prints the string
    mov eax, 4				;4 means sys_write
    mov ebx, 1				;1 means sys_exit
    mov ecx, msg
    mov edx, msgLen
    int 80h				;interrupt

    ;this block asks for input
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    int 80h

    mov byte[nameLen], al

    mov eax, 4
    mov ebx, 1
    mov ecx, name
    mov edx, [nameLen]
    int 80h

    ;this block terminates the program
    mov eax, 1
    mov ebx, 0
    int 80h

