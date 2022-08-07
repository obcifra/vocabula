#!/usr/bin/env bash

tmp_liber=$(mktemp -d /tmp/traferre.XXXXXX)

cat ${1} > ${tmp_liber}/vocabula

if [[ -z "${CONTAINER_RUNTIME}" ]]; then
  docker run -v ${tmp_liber}:/data --rm -t words:latest meanings data/vocabula \
                   | sed 's/^*/@/g' \
                   | sed 's/^[[:space:]]*$/@/g' \
                   > ${tmp_liber}/definitiones
else
  meanings ${tmp_liber}/vocabula \
                   | sed 's/^*/@/g' \
                   | sed 's/^[[:space:]]*$/@/g' \
                   > ${tmp_liber}/definitiones
fi

cat ${tmp_liber}/definitiones

rm -rf "${tmp_liber}"
