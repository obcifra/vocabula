#!/usr/bin/env bash

read scripturae

echo ${scripturae} | sed 's/[[:punct:][:digit:]]//g' \
                   | tr ' ' '\n' \
                   | sed '/^$/d' \
                   | sed '/^a$/d' \
                   | sort -du
