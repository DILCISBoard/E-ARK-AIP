#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

cp -rf "$SCRIPT_DIR/spec-publisher/pandoc/img" "$SCRIPT_DIR/doc/pdf/"
cp -rf "$SCRIPT_DIR/spec-publisher/res/md/figs" "$SCRIPT_DIR/doc/pdf/"
cp -rf "$SCRIPT_DIR/figs" "$SCRIPT_DIR/doc/pdf/"

bash "$SCRIPT_DIR/spec-publisher/utils/create-venv.sh"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname "$(mktemp -u)")
  source "$tmpdir/.venv-markdown/bin/activate"
}
echo " - MARKDOWN-PP: Processing postface markdown"
cd "$SCRIPT_DIR/specification/postface/" || exit
markdown-pp postface-pdf.md -o "$SCRIPT_DIR/doc/pdf/postface.md" -e tableofcontents

cd "$SCRIPT_DIR/doc/pdf" || exit

echo " - PANDOC: Generating Preface from markdown"
pandoc  --from gfm \
        --to latex \
        --metadata-file "$SCRIPT_DIR/spec-publisher/pandoc/metadata.yaml" \
        "./preface.md" \
        -o "./preface.tex"
echo " - PANDOC: Finished"
sed -i 's%section{%section*{%' ./preface.tex

echo " - PANDOC: Generating Postface from markdown"
pandoc  --from gfm \
        --to latex \
        --metadata-file "$SCRIPT_DIR/spec-publisher/pandoc/metadata.yaml" \
        "./postface.md" \
        -o ./postface.tex
sed -i 's%section{%section*{%' ./postface.tex

markdown-pp PDF.md -o eark-aip-pdf.md -e tableofcontents
sed -i 's%fig_2_csip_scope.svg%fig_2_csip_scope.png%' eark-aip-pdf.md

if [ -d "$SCRIPT_DIR/site/pdf" ]
then
  echo " - Removing old site PDF directory"
  rm -rf "$SCRIPT_DIR/site/pdf"
fi
mkdir "$SCRIPT_DIR/site/pdf"

###
# Pandoc options:
# --from markdown \                               # Source fromat Markdown
# --template ../pandoc/templates/eisvogel.latex \ # Use this latex template
# --listings \                                    # Use listings package for code blocks
# --table-of-contents \                           # Generate table of contents
# --metadata-file ../pandoc/metadata.yaml \       # Additional Pandoc metadata
# --include-before-body "../spec-publisher/res/md/common-intro.md" \
# --include-after-body "../specification/postface/postface.md" \
# --number-sections \                             # Generate Heading Numbers
# eark-sip-pdf.md \                              # Input Markdown file
# -o ./pdf/eark-dip.pdf                          # PDF Destinaton
echo " - PANDOC: Generating PDF document from markdown"
# pandoc -s --bibliography "../pandoc/bibliography.bib" --citeproc eark-aip-pdf.md -o cits.html

pandoc  --from markdown \
        --template "$SCRIPT_DIR/spec-publisher/pandoc/templates/eisvogel.latex" \
        --listings \
        --table-of-contents \
        --metadata-file "$SCRIPT_DIR/spec-publisher/pandoc/metadata.yaml" \
        --include-before-body "./preface.tex" \
        --include-after-body "./postface.tex" \
        --number-sections \
        --bibliography "$SCRIPT_DIR/pandoc/bibliography.bib" \
        --filter pandoc-citeproc eark-aip-pdf.md \
        -o "$SCRIPT_DIR/site/pdf/eark-aip.pdf"
echo "PANDOC: Finished"
# rm "$SCRIPT_DIR/docs/preface.tex" "$SCRIPT_DIR/docs/postface.tex" "$SCRIPT_DIR/docs/eark-aip-pdf.md"
cd "$SCRIPT_DIR" || exit
