#!/bin/bash
. ./build.sh

if [ "$?" != "0" ]; then
    echo "Something went wrong! $1" 1>&2
	exit 1
fi


qemu-system-i386 -kernel myos.bin