%include "pc_io.inc"
section .bss
    X resb 4
    Y resb 4
    W resb 8
    tmp resb 32
    ;Inciso A
    A resb 64
    C resb 1
    cad resb 256
    Z resb 4

section .data
    NL: db  13,10
    NL_L:    equ $-NL
    IncisoB: db "Inciso B) ",10,0
    IncisoC: db "Inciso C) ",10,0
    IncisoD: db "Inciso D) ",10,0
    IncisoE: db "Inciso E) ",10,0
    IncisoF: db "Inciso F) ",10,0

section .text
global _start:
    _start:mov esi,cad
    mov dword[X],0x10
    mov dword[Y],0x20

    ;Inciso B
    mov edx,IncisoB
    call puts
    mov eax,3
    mov ebx,0
    mov ecx,A
    mov edx,64
    int 0x80
    mov edx,A
    call puts

    ;Inciso C
    mov edx,IncisoC ;Sin Biblioteca
    call puts
    mov eax,3
    mov ebx,0
    mov ecx,C
    mov edx,1
    int 0x80
    mov al,[C]
    call putchar
    call new_line
    call getch ;Con Biblioteca
    call putchar

    ;Inciso D
    mov edx,IncisoD
    call puts
    call clearReg
    mov eax,[X]
    mov ebx,[Y]
    imul ebx
    mov dword[0x0804A058],eax
    mov eax,[tmp]
    call printHex
    call new_line
    mov [W],eax
    mov eax,[W]
    call printHex
    call new_line

    ;Inciso E
    mov edx,IncisoE
    call puts
    cdq
    mov eax,[W]
    idiv dword[X]
    mov [W],eax
    mov eax,[W]
    call printHex
    call new_line
    lea ecx,Z
    mov [ecx],eax
    mov eax,[Z]
    call printHex
    call new_line

    ;Inciso F
    mov edx,IncisoF
    call puts
    lea ebx,tmp
    neg byte [ebx + 8]
    neg byte [ebx + 9]
    neg byte [ebx + 10]
    neg byte [ebx + 11]
    neg byte [ebx + 12]
    mov eax,[tmp+8]
    call printHex
    mov eax,[tmp+4]
    call printHex
    mov eax,[tmp]
    call printHex
    call new_line

    mov eax,1
    mov ebx,0
    int 0x80

new_line:
    pushad
    mov eax, 4
    mov ebx, 1
    mov ecx, NL
    mov edx, NL_L
    int 0x80
    popad
    ret

printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    .nxt: shr eax,cl
    .msk: and eax,ebx
    cmp al, 9
    jbe .menor
    add al,7
    .menor:add al,'0'
    mov byte [esi],al
    inc esi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk
    .print: mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

clearReg:
    xor eax,eax ; Limpieza De Registros
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx
    ret