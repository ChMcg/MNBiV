    .global main

    .text
main:
    call    emulate_stack

    mov     $0, %rdi
    call    exit


emulate_stack:
    mov     $1, %rdi
    mov     $30, %rsi
    call    calloc

    mov     $0, %rdi
    mov     %rax, %rsi
    mov     $30, %rdx
    push    %rax        # буфер
    call    read    
    dec     %rax        # убираем '\n'
    push    %rax        # количество прочитанных символов

.L1:
    mov     $1, %rdi

    pop     %r12
    pop     %r13
    dec     %r12
    mov     %r12, %rsi
    add     %r13, %rsi
    push    %r13
    push    %r12

    mov     $1, %rdx
    call    write
    cmp     $0, %r12
    jne     .L1

    pop     %rax
    pop     %rax

    call write_empty_line
    ret    

write_empty_line:
    mov     $0x0A, %rdi
    call    putchar
    ret


format:
        .asciz  "%s\n"

