#!/bin/bash

## Download the source code.
if test ! -d "tigcclib/.git"; then
	git clone https://github.com/gcc4ti/tigcclib.git && cd tigcclib || exit 1
else
	cd tigcclib &&
		git pull && git fetch origin &&
		git reset --hard origin/master || exit 1
fi

echo Installing TIGCCLIB...
echo Installing include files...
rm -Rf "$TIGCC/include"
cp -Rf include "$TIGCC/"
# only symlink if the file system is case sensitive
if [ ! -f "$TIGCC/include/asm/OS.h" ]
then ln -sf "os.h" "$TIGCC/include/asm/OS.h"
fi

echo Building tigcc.a, flashos.a and fargo.a...
rm -Rf "$TIGCC/lib"
install -d "$TIGCC/lib"
(cd src && tprbuilder tigcc.tpr && install tigcc.a "$TIGCC/lib" && tprbuilder --clean tigcc.tpr) || exit 1
(cd src && tprbuilder flashos.tpr && install flashos.a "$TIGCC/lib" && tprbuilder --clean flashos.tpr) || exit 1
(cd src && tprbuilder fargo.tpr && install fargo.a "$TIGCC/lib" && tprbuilder --clean fargo.tpr) || exit 1

echo Building pstarter.o...
(cd starters && tprbuilder pstarter.tpr && install pstarter.o "$TIGCC/lib" && tprbuilder --clean pstarter.tpr) || exit 1

echo Installing example files...
rm -Rf "$TIGCC/examples"
cp -Rf examples "$TIGCC"
