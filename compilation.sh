#!/bin/sh

# kernel
echo kernel start `date` >> ~/kompilacja.log
 cd /usr/src/sys/arch/i386/conf
 config GENERIC
 cd ../compile/GENERIC
 make clean && make
 make install
echo kernel stop `date` >> ~/kompilacja.log

# userland
echo userland start `date` >> ~/kompilacja.log
rm -rf /usr/obj/*
cd /usr/src; make obj; cd /usr/src/etc && env DESTDIR=/ make distrib-dirs; cd /usr/src; time make build
echo userland stop `date` >> ~/kompilacja.log
