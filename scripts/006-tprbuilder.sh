#!/bin/bash

## Download the source code.
if test ! -d "tprbuilder/.git"; then
	git clone https://github.com/gcc4ti/tprbuilder.git && cd tprbuilder || exit 1
else
	cd tprbuilder &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

cd src/

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install tprbuilder "$TIGCC/bin/tprbuilder" && make clean || { exit 1; }
