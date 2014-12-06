#!/bin/bash
export SKIPBINUTILS=0
export SKIPGCC=0
export SKIPBINUTILSCROSS=0
export SKIPGCCCROSS=0
export SKIPDOWNLOAD=0
. ./variablesetup.sh

function error_exit
{
	if [ "$?" != "0" ]; then
	    echo "Something went wrong! ( $1 )" 1>&2
		exit 1
	fi
}

echo "downloading"
if [ "$SKIPDOWNLOAD" == "0" ]; then
	if [ ! -f $DOWNLOADDIR/binutils-$BINUTILSVERSION.tar.gz ]; then
		cd $DOWNLOADDIR
		error_exit "$DOWNLOADDIR not found"
		wget ftp://ftp.gnu.org/gnu/binutils/binutils-$BINUTILSVERSION.tar.gz
		error_exit "downloading binutils"
	fi
	if [ ! -f $DOWNLOADDIR/gcc-$GCCVERSION.tar.gz ];then
		cd $DOWNLOADDIR
		error_exit "$DOWNLOADDIR not found"
		wget ftp://ftp.gnu.org/gnu/gcc/gcc-$GCCVERSION/gcc-$GCCVERSION.tar.gz
		error_exit "downloading gcc"
	fi
fi

echo "extracting"
if [ ! -d $SOURCELOCATION/gcc-$GCCVERSION ]; then
	mkdir $SOURCELOCATION
	cd $SOURCELOCATION
	exit_error
	tar -xzvf $DOWNLOADDIR/gcc-$GCCVERSION.tar.gz
	error_exit "unpacking gcc"
fi

if [ ! -d $SOURCELOCATION/binutils-$BINUTILSVERSION ]; then
	mkdir $SOURCELOCATION
	cd $SOURCELOCATION
	exit_error
	tar -xzvf $DOWNLOADDIR/binutils-$BINUTILSVERSION.tar.gz
	error_exit "unpacking binutils"
fi

echo "building prerequisite"
echo "building binutils"
sleep 1
if [ "$SKIPBINUTILS" == "0" ]; then
	cd $SOURCELOCATION
	error_exit
	rm -r build-binutils
	mkdir build-binutils
	cd build-binutils
	error_exit
	../binutils-$BINUTILSVERSION/configure --prefix="$DESTINATION/binutils-$BINUTILSVERSION" --disable-nls
	error_exit
	make
	error_exit
	make install
	error_exit
fi

echo "building gcc"
sleep 1
if [ "$SKIPGCC" == "0" ]; then
	# If you wish to build these packages as part of gcc:
	# mv gmp-$GCCVRSION gcc-$GCCVRSION/gmp
	# mv mpfr-$GCCVRSION gcc-$GCCVRSION/mpfr
	# mv mpc-$GCCVRSION gcc-$GCCVRSION/mpc
	
	cd $SOURCELOCATION
	error_exit
	cd gcc-$GCCVERSION
	error_exit
	#./contrib/download_prerequisites
	error_exit "gcc download_prerequisites"
    cd $SOURCELOCATION
	rm -r build-gcc
	mkdir build-gcc
	cd build-gcc
	error_exit
	$SOURCELOCATION/gcc-$GCCVERSION/configure --prefix="$DESTINATION/gcc-$GCCVERSION" --disable-nls --enable-languages=c
	error_exit "config gcc"
	make
	error_exit "make gcc"
	make install
	error_exit "make install gcc"
fi

echo "DONE building prerequisite"
#echo $PATH
echo "moving on to cross-compiler"
echo " "
export PATH="$DESTINATION/gcc-$GCCVERSION/bin:$PATH"
#echo $PATH


echo "building binutils cross"
sleep 1

if [ "$SKIPBINUTILSCROSS" == "0" ]; then
	# If you wish to build these packages as part of binutils:
	# mv isl-x.y.z gcc-x.y.z/isl
	# mv cloog-x.y.z gcc-x.y.z/cloog
	
	cd $SOURCELOCATION 
	mkdir build-binutils-cross
	cd build-binutils-cross
	../binutils-$BINUTILSVERSION/configure --target=$TARGET --prefix="$DESTINATION/gcc-cross-$GCCVERSION" --with-sysroot --disable-nls --disable-werror
	error_exit
	make
	error_exit
	make install
	error_exit
fi

export PATH="$DESTINATION/gcc-cross-$GCCVERSION/bin:$PATH"

if [ "$SKIPGCCCROSS" == "0" ]; then
	cd $SOURCELOCATION 
	#mv gmp-x.y.z gcc-x.y.z/gmp
	#mv mpfr-x.y.z gcc-x.y.z/mpfr
	#mv mpc-x.y.z gcc-x.y.z/mpc
	#mv isl-x.y.z gcc-x.y.z/isl
	#mv cloog-x.y.z gcc-x.y.z/cloog
	
	echo "building gcc cross"
	sleep 1 
	mkdir build-gcc-cross
	cd build-gcc-cross
	echo "version check:"
	gcc --version
	ar --version
	echo $PATH
	#read -p "Press [Enter] key to continue to config"
	echo "go"
	#unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUD
	../gcc-$GCCVERSION/configure --target=$TARGET --prefix="$DESTINATION/gcc-cross-$GCCVERSION" --disable-nls --enable-languages=c --without-headers
	error_exit "config gcc"
	make all-gcc
	error_exit "cross gcc make all-gcc"
	
	make all-target-libgcc
	error_exit "cross gcc make all-target-libgcc"
	
	make install-gcc
	error_exit "cross gcc make install-gcc"
	
	make install-target-libgcc
	error_exit "cross gcc make install-target-libgcc"
	
	echo "done building gcc cross"
fi