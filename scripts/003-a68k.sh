#!/bin/bash

## Download the source code.
if test ! -d "A68k/.git"; then
	git clone https://github.com/gcc4ti/A68k.git && cd A68k || exit 1
else
	cd A68k &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install A68k "$TIGCC/bin/a68k" && make clean || { exit 1; }
