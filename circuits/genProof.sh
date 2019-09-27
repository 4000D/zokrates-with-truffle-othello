#!/bin/bash
# executed in each sub directory

echo "PWD: $PWD"

echo "zokrates compute-witness -a $@"

../../zokrates compute-witness -a "$@" | tail -1

echo "zokrates generate-proof --proving-scheme pghr13"

../../zokrates generate-proof --proving-scheme pghr13

cat proof.json

rm proof.json
rm witness