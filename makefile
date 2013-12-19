# Set valid shell type
SHELL = /bin/sh

# Enviromental variables
CC=gcc
ASMBIN=nasm

all: link
	@echo "Done, run with ./bin"

link: main.o func.o
	@echo "Linking..."; $(CC) -m32 -o bin -lstdc++ main.o func.o

func.o: func.asm 
	@echo "Compiling func.asm..."; $(ASMBIN) -g -f elf -l func.lst func.asm

main.o: main.cc
	@echo "Compiling main.cc..."; $(CC) -m32 -c -g -O0 main.cc 

clean:
	@echo "Cleaning up..."
	rm *.o
	rm bin
	rm func.lst
	@echo "Done"
