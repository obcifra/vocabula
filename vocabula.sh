#!/usr/bin/env bash

mkdir -p ./cache

tmp_liber=$(mktemp -d /tmp/vocabula.XXXXXX)

if [ -z "$1" ]; then
  echo "Error: Scribe numerum psalmi!"
  exit;
fi

### Vocabula

./acci.sh ${1} | ./munda.sh > ${tmp_liber}/vocabula

### Definitiones

./traferre.sh ${tmp_liber}/vocabula > ${tmp_liber}/definitiones

### Glossarium

./conpara.sh ${1} ${tmp_liber}/vocabula ${tmp_liber}/definitiones

rm -rf "${tmp_liber}"
