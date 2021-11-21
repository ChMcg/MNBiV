#!/usr/bin/env bash

nasm_file=${1}
filename=$(echo ${nasm_file} | sed 's/\.nasm//g')

mkdir -p build

nasm -f elf64 ${nasm_file} -o build/${filename}.o \
    && ld -m elf_x86_64 build/${filename}.o -o build/${filename} \

# build test.c:
# gcc -z execstack -g -ggdb test.c -o build/test && ./build/test
