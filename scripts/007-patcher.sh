#!/bin/bash

## Download the source code.
if test ! -d "patcher/.git"; then
	git clone https://github.com/gcc4ti/patcher.git && cd patcher || exit 1
else
	cd patcher &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

cd src/

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install tigcc-patcher "$TIGCC/bin/tigcc-patcher" && make clean || { exit 1; }
