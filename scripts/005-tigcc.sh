#!/bin/bash

## Download the source code.
if test ! -d "tigcc/.git"; then
	git clone https://github.com/gcc4ti/tigcc.git && cd tigcc || exit 1
else
	cd tigcc &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

cd src/

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install tigcc "$TIGCC/bin/tigcc" && make clean || { exit 1; }
