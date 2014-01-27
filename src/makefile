# Set valid shell type
SHELL = /bin/sh

# Enviromental variables
CC=gcc
ASMBIN=nasm

CC_FLAG= -m32 -c -g -O0 -Wall 
LINKER_FLAG=-m32 -lm -lstdc++
ASM_FLAG=-g -f elf

all: main.o mapa.o przekroj.o	
	@echo "Linking..."; $(CC) $(LINKER_FLAG) -o bin main.o mapa.o przekroj.o
	@echo "Done, run with ./bin"

mapa.o: mapa.asm 
	@echo "Compiling mapa.asm..."; $(ASMBIN) $(ASM_FLAG) -l mapa.lst mapa.asm

przekroj.o: przekroj.asm 
	@echo "Compiling przekroj.asm..."; $(ASMBIN) $(ASM_FLAG) -l przekroj.lst przekroj.asm

main.o: main.cc data.cc
	@echo "Compiling main.cc..."; $(CC) $(CC_FLAG) main.cc 

clean:
	@echo "Removing executable...";rm bin 2>/dev/null || true
	@echo "Cleaning up...";
	@rm *.o 2>/dev/null || true
	@rm *.lst 2>/dev/null || true
	@echo "Done"
