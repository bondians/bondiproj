libJookie.dylib:	*.[ch] Makefile.osx
	gcc -c *.c
	ld -o libJookie.dylib -dylib -ldylib1.o -lSystem *.o

clean:
	rm -f *.o libJookie.dylib

install:	libJookie.dylib
	cp libJookie.dylib /usr/lib
