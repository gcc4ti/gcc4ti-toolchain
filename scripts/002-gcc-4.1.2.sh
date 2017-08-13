#!/bin/bash

GCC_VERSION=4.1.2
## Download the source code.
SOURCE=http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
wget --continue $SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing GCC $GCC_VERSION. Please wait.
rm -Rf gcc-$GCC_VERSION && tar xfj gcc-$GCC_VERSION.tar.bz2 || { exit 1; }

## Enter the source directory and patch the source code.
cd gcc-$GCC_VERSION || { exit 1; }
if [ -e ../../patches/gcc-$GCC_VERSION-TI.patch ]; then
	cat ../../patches/gcc-$GCC_VERSION-TI.patch | patch -p1 || { exit 1; }
fi

## Determine the maximum number of processes that Make can work with.
## MinGW's Make doesn't work properly with multi-core processors.
OSVER=$(uname)
if [ ${OSVER:0:10} == MINGW32_NT ]; then
	PROC_NR=2
elif [ ${OSVER:0:6} == Darwin ]; then
	PROC_NR=$(sysctl -n hw.ncpu)
else
	PROC_NR=$(nproc)
fi

## Create and enter the build directory.
mkdir build && cd build || { exit 1; }

## Configure the build.
../configure --prefix="$TIGCC" --program-prefix=m68k-coff-tigcc- --target=m68k-coff --enable-languages="c" --with-gnu-as --disable-nls --disable-multilib --disable-shared --enable-static --disable-threads --disable-win32-registry --disable-checking --disable-werror --disable-pch --disable-mudflap --disable-libssp || { exit 1; }

## Compile and install.
make clean && make -i -j $PROC_NR && make -i install && install gcc/xgcc "$TIGCC/bin/m68k-coff-tigcc-gcc" && make clean || { exit 1; }

## Prepare the installation.
mv "$TIGCC/libexec/gcc/m68k-coff/4.1.2/cc1" "$TIGCC/bin/" || exit 1
rm -f "$TIGCC/bin/m68k-coff-gcc-4.1.2"
rm -f "$TIGCC/bin/m68k-coff-tigcc-cpp"
rm -f "$TIGCC/bin/m68k-coff-tigcc-gccbug*"
rm -f "$TIGCC/bin/m68k-coff-tigcc-gcov"
rm -rf "$TIGCC/info"
rm -rf "$TIGCC/libexec"
rm -rf "$TIGCC/m68k-coff"
rm -rf "$TIGCC/man"
rm -rf "$TIGCC/share"

## Exit the build directory.
cd .. || { exit 1; }
