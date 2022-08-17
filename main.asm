;Exame de Linguagem de Montagem
;Gabriel Mazzuco
;17/08/2022

;Chamada externa das funções
extern printf
extern scanf
extern fopen
extern fclose
extern fprintf

section .data

    ;Entrada de dados dos pontos 1
    entrada1 : db "entrada com o ponto 1 (x.x y.y z.z): ", 0
    entrada1L : equ $-entrada1

    enter1 : db "%lf %lf %lf", 0
    enter1L : equ $-enter1

    ;Entrada de dados dos pontos 2
    entrada2 : db "entrada com o ponto 2 (x.x y.y z.z): ", 0
    entrada2L : equ $-entrada2

    enter2 : db "%lf %lf %lf", 0
    enter2L : equ $-enter2

    ;Saida do arquivo
    saida : db "%lf", 10 ,0
    saidaL : equ $-saida

    ;Definição do arquivo
    nome_arquivo : db "resultado.txt", 0
    permissao_escrita : db "w", 0


section .bss

    ;Vetores P1 e P2
    p1 : resq 3
    p2 : resq 3

    ;Resultado da equação
    p_resultado : resq 16

    ;Definição do fopen
    result_handle : resq 1

section .text
    global main

main:
    ;Stack Frame
    push rbp
    mov rbp, rsp

    ;Entradas dos primeiros numeros
    call zera_registradores ;Chamada para zerar os arquivos

    ;Primeiro printf: "entrada com o ponto 1 (x.x y.y z.z):"
    mov rdi, entrada1
    call printf

    call zera_registradores

    ;Primeiro scanf: "%lf %lf %lf"
    mov rdi, enter1
    lea rsi, [p1]
    lea rdx, [p1 + 8]
    lea rcx, [p1 + 16]
    call scanf

    ;======================================;

    ;Entradas dos segundos numeros
    call zera_registradores

    ;Segundo printf: "entrada com o ponto 2 (x.x y.y z.z):"
    mov rdi, entrada2
    call printf

    call zera_registradores

    ;Segundo scanf: "%lf %lf %lf"
    mov rdi, enter2
    lea rsi, [p2]
    lea rdx, [p2 + 8]
    lea rcx, [p2 + 16]
    call scanf

    call zera_registradores

    ;Passagem de paramentro para a função dis3Dlm
    lea rdi, [p1]
    lea rsi, [p2]
    call dis3Dlm

    ;Chamada printa no arquivo
    call arquivo

    ;Pula para o fim do programa
    jmp fim

fim:

    ;Finaliza a pilha
    mov rsp, rbp
    pop rbp

    ;Fecha o programa
    mov rax, 60
    mov rdi, 0
    syscall

zera_registradores:
    ;Função para zerar os registradores especificos para
    ;as funções

    xor rax, rax
    xor rdi, rdi
    xor rsi, rsi

    ret

arquivo:

    call zera_registradores

    ;Abertura do arquivo usando fopen()
    mov rdi, nome_arquivo        ;'resultado.txt'
    mov rsi, permissao_escrita   ;'w' -> recria o arquivo e escreve dentro
    call fopen
    mov [result_handle], rax     ;salva o valor se o arquivo foi aberto e criado

    call zera_registradores

    ;Save point do resultado, para ser usado do fprintf()
    ;xmm12 vem diretamente da execução da raiz quadrada na
    ;função dis3Dlm()
    movsd xmm0, xmm12

    ;Escreve no arquivo usando fprintf()
    mov rdi, [result_handle]    ;Retorno do fopen()
    mov rsi, saida              ;%lf -> resultado
    mov rax, 1                  ;xmmo
    sub rsp, 8                  ;Alinhamento da pilha
    call fprintf
    add rsp, 8                  ;Alinhamento da pilha

    ;Fecha arquivo usando fclose()
    mov rdi, [result_handle]
    call fclose

    ret

dis3Dlm:
    ;Calculo √(x1 - x2)² + (y1 - y2)² + (z1 - z2)²

    ;Efetua o calculo de (x1 - x2)²
    ;Registra no registrador o valor passado diretamente do vetor
    movsd xmm0, [rdi]
    movsd xmm1, [rsi]

    ;Alinha a pilha para efetuar o calculo
    push rbp
    mov rbp, rsp

    ;Subtração
    subsd xmm0, xmm1

    ;Exponenciação
    mulsd xmm0, xmm0

    ;Salva o valor resposta em xmm13
    movsd xmm13, xmm0

    ;==================================;

    ;Efetua o calculo de (y1 - y2)²
    ;Registra no registrador o valor passado diretamente do vetor
    movsd xmm0, [rdi+8]
    movsd xmm1, [rsi+8]

    ;Subtração
    subsd xmm0, xmm1

    ;Exponenciação
    mulsd xmm0, xmm0

    ;Salva o valor resposta em xmm14
    movsd xmm14, xmm0

    ;==================================;

    ;Efetua o calculo de (z1 - z2)²
    ;Registra no registrador o valor passado diretamente do vetor
    movsd xmm0, [rsi+16]
    movsd xmm1, [rdi+16]

    ;Subtração
    subsd xmm0, xmm1

    ;Exponenciação
    mulsd xmm0, xmm0

    ;Salva o valor resposta
    movsd xmm15, xmm0

    ;=============================;
    ;Soma dos valores antes da execução da raiz quadrada
    ;salvando o valor resposta dentro de xmm13
    
    ;Soma r1 = (x1 - x2)² + (y1 - y2)²
    addsd xmm13, xmm14

    ;Soma r2 = r1 + (z1 - z2)²
    addsd xmm13, xmm15

    ;=============================;
    ;Efetua a raiz quadrada do valor dentro de xmm13
    ;salvando o novo valor resposta em xmm12
    sqrtsd xmm12, xmm13

    ;Finaliza a execução dentro da pilha
    mov rsp, rbp
    pop rbp

    ;Retorna a função
    ret
