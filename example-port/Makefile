CC ?= gcc
CFLAGS ?= -O2 -pipe
DESTDIR ?= stage
PREFIX ?= /usr/local

all: hello-tiramisu

hello-tiramisu: main.c
	$(CC) $(CFLAGS) -o hello-tiramisu main.c

install: hello-tiramisu
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 hello-tiramisu $(DESTDIR)$(PREFIX)/bin/

clean:
	rm -f hello-tiramisu
	rm -rf stage
