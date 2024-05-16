#!/usr/bin/env bash
echo "Generating GitHub pages site from markdown"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit

echo " - Cleaning up site directory and copying spec-publisher site..."
# git clean -f doc/ site/ specification/
cp -rf spec-publisher/site/* site/

mvn package -f spec-publisher/pom.xml
java -jar ./spec-publisher/target/mets-profile-processor-0.1.0-SNAPSHOT.jar -f ./specification.yaml -o doc/site profile/E-ARK-AIP-v2-2-0.xml

mkdir ./site/release-notes
cp ./RELEASENOTES.md ./docs/release-notes/index.md

bash "$SCRIPT_DIR/spec-publisher/scripts/create-venv.sh"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname "$(mktemp -u)")
  source "$tmpdir/.venv-markdown/bin/activate"
}
echo " - MARKDOWN-PP: generating site page with TOC..."
cd "$SCRIPT_DIR/doc/site" || exit
bash "$SCRIPT_DIR/spec-publisher/scripts/create-venv.sh"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname "$(mktemp -u)")
  source "$tmpdir/.venv-markdown/bin/activate"
}
markdown-pp body.md -o body_toc.md

echo " - MARKDOWN-PP: generating site index.md..."
markdown-pp SITE.md -o ../../site/index.md

cd "$SCRIPT_DIR" || exit

echo " - copying files to docs directory"
cp -Rf spec-publisher/res/md/figs site/
cp -Rf spec-publisher/site/* site/
find ./site/_* -type f -exec sed -i 's/CSIP/AIP/' {} \;
find ./site/_* -type f -exec sed -i 's/csip/aip/' {} \;
cp -R figs profile archive examples site/
