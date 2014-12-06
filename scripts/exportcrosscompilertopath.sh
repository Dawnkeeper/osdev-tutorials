#!/bin/bash
. ../scripts/variablesetup.sh
export PATH="$DESTINATION/gcc-cross-$GCCVERSION/bin:$DESTINATION/gcc-$GCCVERSION/bin:$PATH"
# :$DESTINATION/binutils-cross-$BINUTILSVERSION/bin :$DESTINATION/binutils-$BINUTILSVERSION/bin
#echo "Path set to:"
#echo "$PATH"