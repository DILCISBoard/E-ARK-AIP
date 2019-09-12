#!/usr/bin/env bash
echo "Generating GitHub pages site from markdown"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit


if [ ! -d ./docs ]
then
  mkdir ./docs
fi

if [ -d ./docs/figs ]
then
  rm -rf ./docs/figs
fi

if [ -e ./docs/index.md ]
then
  rm docs/index.md
fi

cp -R spec-publisher/res/md/figs/* figs/
cp -R figs docs/
cp -R profiles docs/
cp -R archived docs/

bash "$SCRIPT_DIR/spec-publisher/utils/create-venv.sh"
command -v markdown-pp >/dev/null 2>&1 || {
  tmpdir=$(dirname $(mktemp -u))
  source "$tmpdir/.venv-markdown/bin/activate"
}
markdown-pp SITE_BASE.md -o /tmp/site.md
markdown-pp SITE.md -o ./docs/index.md
