#!/bin/bash

## Download the source code.
if test ! -d "ld-tigcc/.git"; then
	git clone https://github.com/gcc4ti/ld-tigcc.git && cd ld-tigcc || exit 1
else
	cd ld-tigcc &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install ld-tigcc "$TIGCC/bin/ld-tigcc" && install ar-tigcc "$TIGCC/bin/ar-tigcc" && make clean || { exit 1; }
