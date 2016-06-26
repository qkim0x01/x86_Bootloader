#!bin/bash

#qemu-system-i386 -L . -boot c -m 256 -hda $1 -soundhw all -localtime -M pc

qemu-system-i386 -L . -boot c -gdb tcp::1234 -m 256 -hda os.bin -soundhw all -localtime -M pc
