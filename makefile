all:
	nasm -f elf64 main.asm
	gcc -m64 -no-pie main.o -o main.x
	./main.x