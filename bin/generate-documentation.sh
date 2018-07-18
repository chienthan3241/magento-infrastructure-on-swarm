#!/bin/bash

root="$( cd $(dirname $0); cd ..; pwd )"
html="$root/html"
mkdir -p "$html"
echo "==> README.md"
pandoc -s -f gfm "$root/README.md" -o "$html/README.html"
for f in $(ls "$root/doc")
do
    if [[ $f != *.md ]]; then
	continue
    fi
    echo "==> $f"
    pandoc -s -f gfm "$root/doc/$f" -o "$html/$(basename $f .md).html"
done
