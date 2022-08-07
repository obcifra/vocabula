#!/usr/bin/env bash

mkdir -p ./cache

tmp_liber=$(mktemp -d /tmp/conpara.XXXXXX)

if [[ ! -f "$2" && ! -f "$3" ]]; then
  echo "Error: ./conpara.sh psalmum vocabula definitiones"
  exit
fi

### Vocabula

vocabula=$(cat ${2})

readarray -t arr_vocabula < <(printf '%s' "$vocabula")

### Definitiones

definitiones=$(cat ${3})

readarray -td '@' arr_definitiones < <(printf '%s' "$definitiones")

### Glossarium

for i in "${!arr_vocabula[@]}"; do
  printf "\n{%s}\n<<\n%s\n>>" "${arr_vocabula[$i]}" "${arr_definitiones[$i]}" \
    >> ${tmp_liber}/glossarium
done

gawk -f scriptum.awk \
     -v psalmum=${1} \
     ${tmp_liber}/glossarium > ${tmp_liber}/liber

groff -ms -Tpdf ${tmp_liber}/liber > psalmum_${1}.pdf

rm -rf "${tmp_liber}"
