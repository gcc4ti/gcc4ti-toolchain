#!/bin/bash

BINUTILS_VERSION=2.16.1
## Download the source code.
SOURCE=http://ftpmirror.gnu.org/binutils/binutils-$BINUTILS_VERSION.tar.bz2
wget --continue $SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing Binutils $BINUTILS_VERSION. Please wait.
rm -Rf binutils-$BINUTILS_VERSION && tar xfj binutils-$BINUTILS_VERSION.tar.bz2 || { exit 1; }

## Enter the source directory and patch the source code.
cd binutils-$BINUTILS_VERSION || { exit 1; }
if [ -e ../../patches/binutils-$BINUTILS_VERSION-TI.patch ]; then
	cat ../../patches/binutils-$BINUTILS_VERSION-TI.patch | patch -p1 || { exit 1; }
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
if [ ${OSVER:0:6} == Darwin ]; then
CC=/usr/bin/gcc CXX=/usr/bin/g++ LD=/usr/bin/ld CFLAGS="-O2 -Wno-implicit-int -Wno-return-type" ../configure "--prefix=$TIGCC" --program-prefix=m68k-coff-tigcc- --target=m68k-coff --disable-shared --enable-static --disable-multilib --disable-nls --disable-win32-registry --without-gnu-ld || { exit 1; }
else
../configure --prefix="$TIGCC" --program-prefix=m68k-coff-tigcc- --target=m68k-coff --disable-shared --enable-static --disable-multilib --disable-nls --disable-win32-registry --without-gnu-ld || { exit 1; }
fi

## Compile and install.
make clean && make -j $PROC_NR && make install && make clean || { exit 1; }

## Prepare the installation.
rm -f "$TIGCC/bin/m68k-coff-tigcc-addr2line"
# tigcc -ar / ar-tigcc has never been a complete replacement for ar.
# rm -f "$TIGCC/bin/m68k-coff-tigcc-ar"
rm -f "$TIGCC/bin/m68k-coff-tigcc-c++filt"
rm -f "$TIGCC/bin/m68k-coff-tigcc-cxxfilt"
rm -f "$TIGCC/bin/m68k-coff-tigcc-ld"
rm -f "$TIGCC/bin/m68k-coff-tigcc-ranlib"
rm -f "$TIGCC/bin/m68k-coff-tigcc-readelf"
rm -f "$TIGCC/bin/m68k-coff-tigcc-strings"
rm -rf "$TIGCC/info"
rm -rf "$TIGCC/libexec"
rm -rf "$TIGCC/m68k-coff"
rm -rf "$TIGCC/man"
rm -rf "$TIGCC/share"

## Exit the build directory.
cd .. || { exit 1; }
