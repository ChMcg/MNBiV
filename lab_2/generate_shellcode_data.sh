#!/usr/bin/env bash

FILE=${1}

objdump -d ${FILE} \
    | grep '[0-91a-f]:' \
    | grep -v 'файл' \
    | cut -f2 -d: \
    | cut -f1-7 -d' ' \
    | tr -s ' ' \
    | tr 't' ' ' \
    | sed 's/ $//g' \
    | sed 's/[\t ]//g' \
    | paste -d '' -s
