# original script from: https://gist.github.com/mharju/1540062

CC=gcc
EXE=ibniz
LFLAGS=-framework SDL -framework Cocoa
FLAGS=-I/Library/Frameworks/SDL.Framework/Headers
all: ibniz

clean:
	rm -f *.o *~ ibniz vmtest ibniz.exe

package: clean
	cd .. && tar czf ibniz-1.1.tar.gz ibniz-1.1/

# added compiler.o

$(EXE): ui_sdl.o vm_slow.o clipboard.o compiler.o
	$(CC) $(FLAGS) -Os ui_sdl.o vm_slow.o clipboard.o compiler.o SDLmain.m -o $(EXE) $(LFLAGS) -lm

ui_sdl.o: ui_sdl.c ibniz.h font.i vm.h texts.i
	$(CC) -c -Os ui_sdl.c -o ui_sdl.o $(FLAGS)

clipboard.o: clipboard.c ibniz.h
	$(CC) -c -Os clipboard.c -o clipboard.o $(FLAGS)

vm_slow.o: vm_slow.c ibniz.h vm.h
	$(CC) -c -O3 vm_slow.c -o vm_slow.o

# added lines

compiler.o: compiler.c ibniz.h gen.h gen_x86.c
	$(CC) -c -O3 compiler.c -o compiler.o $(FLAGS)

font.i: font.pl
	perl font.pl > font.i

runtest: vmtest
	./vmtest

vmtest: vm_test.c vm_slow.c
	gcc vm_test.c vm_slow.c -o vmtest -lm
