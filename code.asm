section .data
    filename db 'main.rug', 0
    buffer times 256 db 0
    variavel_a dq 0
    variavel_b dq 0
    newline db 10

section .bss
    bytesRead resq 1

section .text
    global _start

_start:
    mov rax, 2
    mov rdi, filename
    mov esi, 0
    syscall
    mov r12,rax

read_loop:
    mov rax, 0
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 256
    syscall
    cmp rax, 0
    je done
    mov rsi [bytesRead], rax
    mov rsi, buffer

parse_line:
    mov rdi, set_token
    call str_cmp
    cmp rax, 0
    jne check_print

    call handle_set
    jmp next_line

check_print:
    mov rdi, print_token
    call str_cmp
    cmp rax, 0
    jne next_line

    call handle_print

next_line:
    jmp done

str_cmp:
    push rsi
    push rdi
    xor rcx, rcx

compare_loop:
    mov al, [rsi + rcx]
    mov bl, [rdi + rcx]
    cmp bl, 0
    je str_cmd_done
    cmp al, bl
    jne str_cmd_not_equal
    inc rcx
    jmp compare_loop

done:
    mov rax, 60
    xor rdi, rdi
    syscall

str_cmd_done:
    xor rax, rax
    pop rdi
    pop rsi
    ret

str_cmd_not_equal:
    mov rax, 1
    pop rdi
    pop rsi
    ret

handle_set: ;seta valor pq nao lembro como ler :)
    mov rax, 6
    mov [variavel_a], rax
    mov rax, 3
    mov [variavel_b], rax
    ret

handle_print:
    mov rax, [variavel_a]
    add rax, [variavel_b]

    add al, '0'

    mov rsi, rsp
    mov [rsi], al
    mov byte [rsi+1], 10

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov edx, 2
    ret

section .data
set_token db 'set', 0
print_token db 'print', 0
