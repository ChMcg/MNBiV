#!/usr/bin/env bash

c_file=${1}
filename=$(echo ${c_file} | sed 's/\.c//g')

gcc -z execstack -g -ggdb ${c_file} -o build/${filename}
