#!/bin/sh

## Check if $TIGCC is set.
if test ! $TIGCC; then { echo "ERROR: Set \$TIGCC before continuing."; exit 1; } fi

## Check for the $TIGCC directory.
ls -ld $TIGCC 1> /dev/null || mkdir -p $TIGCC 1> /dev/null || { echo "ERROR: Create $TIGCC before continuing."; exit 1; }

## Check for $TIGCC write permission.
touch $TIGCC/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $TIGCC before continuing."; exit 1; }

## Check for $TIGCC/bin in the path.
echo $PATH | grep $TIGCC/bin 1> /dev/null || { echo "ERROR: Add $TIGCC/bin to your path before continuing."; exit 1; }
