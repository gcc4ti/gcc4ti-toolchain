#!/bin/bash

## Download the source code.
if test ! -d "tools/.git"; then
	git clone https://github.com/gcc4ti/tools.git && cd tools || exit 1
else
	cd tools &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

## Build and install.
./buildall && install -d "$TIGCC/bin" && install bin/* "$TIGCC/bin" && ./clean || { exit 1; }
