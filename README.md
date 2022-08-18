# Exame de Linguagem de Montagem (LM)
>Colaborador: Gabriel Mazzuco ([Github Profile](https://github.com/gabrielmazz))

>Professor: Edmar Bellorini

---

## Conteúdo:

O programa deve criar dois vetores, aonde recebera os valores dos primeiros pontos e depois dos próximos. 

- Os valores de entrada, deve ser valores ponto-flutuante de precisão dupla
- Usando uma função chamada dis3Dlm com passagem de parametro por ponteiro
    ```c
    dis3Dlm(double* p1, double* p2)
    ```

$$
\sqrt{(x_1 - x_2)^2 + (y_1 - y_2)^2 + (z_1 - z_2)^2}
$$

## Restrições:

- Deve se usar funções do C dentro do programa
    ```c
    extern printf
        - int printf(const char *format, ...);

    extern scanf
        - int scanf(const char *format, ...);

    extern fprintf
        - int fprintf(FILE *stream, const char *format, ...);

    extern fopen
        - int fopen(const char *filename, const char *mode);

    extern fclose
        - int fclose(FILE *stream)
    ```

- Deve tambem printar dentro de um arquivo externo, usando 'w' para usado para recriar o arquivo toda vez que uma nova execução é feita

## Execução:

- Pode se usar o makefile para compilar e executar
    ```make
    make
    ```

- Ou compilar e executar manualmente
    ```
    nasm -f elf64 main.asm
    gcc -m64 -no-pie main.o -o main.x
    ./main.x
    ```
