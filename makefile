# Set valid shell type
SHELL = /bin/sh

# Enviromental variables
CC=gcc
ASMBIN=nasm

all: main.o mapa.o przekroj.o	
	@echo "Linking..."; $(CC) -m32 -o bin -lstdc++ main.o mapa.o przekroj.o
	@echo "Done, run with ./bin"

mapa.o: mapa.asm 
	@echo "Compiling mapa.asm..."; $(ASMBIN) -g -f elf -l mapa.lst mapa.asm

przekroj.o: przekroj.asm 
	@echo "Compiling przekroj.asm..."; $(ASMBIN) -g -f elf -l przekroj.lst przekroj.asm

main.o: main.cc
	@echo "Compiling main.cc..."; $(CC) -m32 -c -g -O0 main.cc 

clean:
	@echo "Removing executable...";rm bin 2>/dev/null || true
	@echo "Cleaning up...";
	@rm *.o 2>/dev/null || true
	@rm *.lst 2>/dev/null || true
	@echo "Done"
