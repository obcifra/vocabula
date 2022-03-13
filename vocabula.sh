#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Error: Scribe numerum psalmi!"
  exit;
fi

psalter="https://raw.githubusercontent.com/DivinumOfficium/divinum-officium/master/"
psalmum="${psalter}/web/www/horas/Latin/psalms/Psalm${1}.txt"

scripturae=$(curl -sL "${psalmum}")
vocabula=$(echo ${scripturae} | sed 's/[[:punct:][:digit:]]//g' \
                              | tr ' ' '\n' \
                              | sort -du)

tmp_liber=$(mktemp /tmp/vocabula.XXXXXX)

echo ${vocabula} > ${tmp_liber}
./bin/meanings ${tmp_liber} | \
  awk '/\[[A-Z]+\]/ {print $0; getline; printf "\t%s\n\n",$0}'
rm "${tmp_liber}"
