#!/bin/bash

## Download the keys from Brandon Wilson's website.
SOURCE=http://brandonw.net/calcstuff/keys.zip
wget --continue $SOURCE || { exit 1; }

## Unpack the keys to the rabbitsign directory.
echo Decompressing the magic keys. Please wait.
unzip -o -d "$TIGCC/share/rabbitsign" keys.zip || { exit 1; }
