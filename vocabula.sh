#!/usr/bin/env bash

mkdir -p ./cache

tmp_liber=$(mktemp -d /tmp/vocabula.XXXXXX)

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

### Vocabula

echo ${scripturae} | sed 's/[[:punct:][:digit:]]//g' \
                   | tr ' ' '\n' \
                   | sed '/^$/d' \
                   | sed '/^a$/d' \
                   | sort -du \
                   > ${tmp_liber}/vocabula

vocabula=$(cat ${tmp_liber}/vocabula)

readarray -t arr_vocabula < <(printf '%s' "$vocabula")

### Definitiones

if [[ -z "${CONTAINER_RUNTIME}" ]]; then
  docker run -v ${tmp_liber}:/data --rm -it words:latest meanings data/vocabula \
                   | sed 's/^*/@/g' \
                   | sed 's/^[[:space:]]*$/@/g' \
                   > ${tmp_liber}/definitiones
else
  meanings ${tmp_liber}/vocabula \
                   | sed 's/^*/@/g' \
                   | sed 's/^[[:space:]]*$/@/g' \
                   > ${tmp_liber}/definitiones
fi

definitiones=$(cat ${tmp_liber}/definitiones)

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
