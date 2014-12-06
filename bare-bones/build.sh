#!/bin/bash
. ../scripts/exportcrosscompilertopath.sh
function error_exit
{
	if [ "$?" != "0" ]; then
	    echo "Something went wrong! $1" 1>&2
		exit 1
	fi
}

i686-elf-as boot.s -o boot.o
error_exit "at boot.o"
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
error_exit "at kernel.c"
i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
error_exit "at linking"