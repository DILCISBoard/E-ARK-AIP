#!/usr/bin/env bash
echo "Generating PDF document from markdown"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

if [ ! -d ~/.pandoc/templates ]
then
  mkdir -p ~/.pandoc/templates

fi
cp spec-publisher/pandoc/templates/eisvogel.latex ~/.pandoc/templates/eisvogel.latex

if [ ! -d "$SCRIPT_DIR/docs/pdf" ]
then
  mkdir -p "$SCRIPT_DIR/docs/pdf/"
fi

pandoc --from markdown \
       --template eisvogel \
       dummy.md \
       pandoc/geo.yaml \
       -o docs/pdf/geo.pdf
