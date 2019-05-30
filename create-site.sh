#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit
bundle install
bundle exec jekyll build
bundle exec htmlproofer ./_site --file-ignore /javadoc/ --only-4xx --check-html
