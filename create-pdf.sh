#!/usr/bin/env bash
echo "Generating PDF document from markdown"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

if [ ! -d ~/.pandoc/templates ]
then
  mkdir -p ~/.pandoc/templates

fi
cp spec-publisher/pandoc/templates/eisvogel.latex ~/.pandoc/templates/eisvogel.latex

bash "$SCRIPT_DIR/spec-publisher/utils/create-venv.sh"
source "$SCRIPT_DIR/.venv/markdown/bin/activate"
markdown-pp index.md -o docs/pdf.md -e tableofcontents
deactivate

if [ ! -d "$SCRIPT_DIR/docs/pdf" ]
then
  mkdir -p "$SCRIPT_DIR/docs/pdf/"
fi

pandoc --include-before-body pandoc/include-before.tex \
       --reference-links \
       --filter pandoc-citeproc \
       --from markdown \
       --template eisvogel \
       --listings \
       --toc \
       --number-sections \
       docs/pdf.md \
       pandoc/metadata.yaml \
       -o docs/pdf/aip-specification.pdf
