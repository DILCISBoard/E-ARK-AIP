# Create PDF using pandoc

Copy the latex template to pandoc's template directory:

    cp pandoc/templates/eisvogel.latex ~/.pandoc/templates/

Run `pandoc` from the project's root folder (where the markdown source file `index.md` is located):

    pandoc --from markdown --template eisvogel --listings --toc --number-sections index.md pandoc/metadata.yaml -o aip-specification.pdf

Note: Latex template based on: https://github.com/Wandmalfarbe/pandoc-latex-template

