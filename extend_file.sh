#!/bin/bash

#TODO: Maybe do this for multiple files
file_size=`stat -c '%s' kernel.bin`
add_size=$(( 512 - file_size % 512))

truncate -s +$add_size kernel.bin
