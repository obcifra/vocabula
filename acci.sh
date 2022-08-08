#!/usr/bin/env bash

mkdir -p ./cache

if [ -z "$1" ]; then
  echo "Error: Scribe numerum psalmi!"
  exit;
fi

psalter="https://raw.githubusercontent.com/DivinumOfficium/divinum-officium/master/"
psalmum="${psalter}/web/www/horas/Latin/psalms/Psalm${1}.txt"
scripturae=""

if [[ ! -f "./cache/${1}.in" ]]; then
  scripturae=$(curl -sL "${psalmum}")
else
  scripturae=$(cat "./cache/${1}.in")
fi

echo ${scripturae}
