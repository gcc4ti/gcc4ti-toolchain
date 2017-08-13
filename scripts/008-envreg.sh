#!/bin/bash

## Download the source code.
if test ! -d "envreg/.git"; then
	git clone https://github.com/gcc4ti/envreg.git && cd envreg || exit 1
else
	cd envreg &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

cd src/

## Build and install.
make clean && make && install -d "$TIGCC/bin" && install envreg "$TIGCC/bin/envreg" && make clean || { exit 1; }
