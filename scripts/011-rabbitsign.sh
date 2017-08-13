#!/bin/bash

## Download the source code.
SOURCE=http://www.ticalc.org/pub/unix/rabbitsign.tar.gz
wget --continue --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" $SOURCE || { exit 1; }

## Unpack the source code.
echo Decompressing RabbitSign 2.1. Please wait.
rm -Rf rabbitsign-2.1 && tar xfz rabbitsign.tar.gz || { exit 1; }

## Enter the source directory.
cd rabbitsign-2.1 || { exit 1; }

## Create and enter the build directory.
mkdir build && cd build || { exit 1; }

## Build and install.
../configure --prefix="$TIGCC" && make && make install && make clean || { exit 1; }
