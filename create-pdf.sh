#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit
pandoc --include-before-body pandoc/include-before.tex \
       --reference-links \
       --filter pandoc-citeproc \
       --from markdown \
       --template eisvogel \
       --listings \
       --toc \
       --number-sections \
       index.md \
       pandoc/metadata.yaml \
       -o published/pdf/aip-specification.pdf
