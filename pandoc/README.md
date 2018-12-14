# Create PDF using pandoc

Copy the latex template to pandoc's template directory:

    cp pandoc/templates/eisvogel.latex ~/.pandoc/templates/

Run `pandoc` from the project's root folder (where the markdown source file `index.md` is located):

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
        -o aip-specification.pdf

* Pandoc parameters are defined in the `pandoc/metadata.yaml` metadata file.
* Sections which are not listed in the table of contents, are included in the `pandoc/include-before.tex` file

Note: Latex template based on: https://github.com/Wandmalfarbe/pandoc-latex-template

