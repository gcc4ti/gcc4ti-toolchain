#!/bin/bash

## Enter the gcc4ti-cleanup directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the gcc4ti-cleanup directory."; exit 1; }

## Set up the environment.
export TIGCC=/usr/local/gcc4ti
export PATH=$PATH:$TIGCC/bin

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
