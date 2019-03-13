build/main: build/main.o build/transbank.o
	cc -o build/main build/main.o build/transbank.o -lserialport
build/main.o: examples/main.c src/transbank.h
	cc -c -g examples/main.c -o build/main.o -I./src
build/transbank.o: src/transbank.h src/transbank.c
	cc -c -g src/transbank.c -o build/transbank.o
run: build/main build/main.o build/Transbank.o
	./build/main
debug: src/main.c src/transbank.h src/transbank.c
	export LIBSERIALPORT_DEBUG=1 && ./build/main && unset LIBSERIALPORT_DEBUG

wraper:
	swig -csharp -o build/transbank_wrap.c -namespace Transbank.POS src/transbank.i
	cd build && cc -fpic -c ../src/transbank.c transbank_wrap.c -I../src
	cc -dynamiclib build/transbank.o build/transbank_wrap.o -o build/Transbank.dylib -lserialport
	sudo cp build/Transbank.dylib /usr/local/lib
windows-wraper:
	swig -csharp -o build/transbank_wrap.c -namespace Transbank.POS src/transbank.i
	cd build && cc -fpic -c ../src/transbank.c transbank_wrap.c -I../src
	cc -shared build/transbank.o build/transbank_wrap.o -o build/Transbank.dll -lserialport
	cp build/Transbank.dll /c/msys64/mingw64/bin
clean:
	rm -rf build/*
