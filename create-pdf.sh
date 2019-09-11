#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

cd "./postface/"
bash "$SCRIPT_DIR/spec-publisher/utils/create-venv.sh"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname $(mktemp -u))
  source "$tmpdir/.venv-markdown/bin/activate"
}
echo " - MARKDOWN-PP: Processing postface markdown"
markdown-pp postface.md -o "$SCRIPT_DIR/docs/postface.md" -e tableofcontents

cd "$SCRIPT_DIR/docs" || exit

echo " - PANDOC: Generating Preface from markdown"
pandoc  --from gfm \
        --to latex \
        --metadata-file "../spec-publisher/pandoc/metadata.yaml" \
        "../spec-publisher/res/md/common-intro.md" \
        -o "./preface.tex"
echo " - PANDOC: Finished"
sed -i 's%fig_1_dip.svg%fig_1_dip.png%' ./preface.tex
sed -i 's%section{%section*{%' ./preface.tex

echo " - PANDOC: Generating Postface from markdown"
pandoc  --from gfm \
        --to latex \
        --metadata-file "../spec-publisher/pandoc/metadata.yaml" \
        "$SCRIPT_DIR/docs/postface.md" \
        -o ./postface.tex
sed -i 's%section{%section*{%' ./postface.tex
rm "$SCRIPT_DIR/docs/postface.md"

if [ ! -d "$SCRIPT_DIR/docs/pdf" ]
then
  mkdir -p "$SCRIPT_DIR/docs/pdf/"
fi

cd "$SCRIPT_DIR" || exit

echo " - MARKDOWN-PP: Preparing PDF markdown"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname $(mktemp -u))
  source "$tmpdir/.venv-markdown/bin/activate"
}
markdown-pp PDF.md -o docs/eark-aip-pdf.md -e tableofcontents

cd docs || exit

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
pandoc  --from markdown \
        --template "../spec-publisher/pandoc/templates/eisvogel.latex" \
        --listings \
        --table-of-contents \
        --metadata-file "../spec-publisher/pandoc/metadata.yaml" \
        --include-before-body "./preface.tex" \
        --include-after-body "./postface.tex" \
        --number-sections \
        eark-aip-pdf.md \
        -o "./pdf/eark-aip.pdf"
echo "PANDOC: Finished"
rm "$SCRIPT_DIR/docs/preface.tex" "$SCRIPT_DIR/docs/postface.tex" "$SCRIPT_DIR/docs/eark-aip-pdf.md"
cd "$SCRIPT_DIR" || exit
