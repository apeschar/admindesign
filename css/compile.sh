#!/bin/bash

set -eu
cd `dirname "$0"`

which sass >/dev/null || export PATH="/var/lib/gems/1.8/bin:$PATH"

compile() {
  files=`ls *.sass 2>/dev/null || echo -n`
  if [ "x$files" != "x" ]
  then
    for sass_file in *.sass
    do
      css_file=${sass_file%.sass}.css
      if [ ! -f "$css_file" ] || [ "$sass_file" -nt "$css_file" ]
      then
        sass < "$sass_file" > "$css_file~"
        mv "$css_file~" "$css_file"
        echo "+$css_file"
      fi
    done
  fi
}

if [ "${1:-}" = "-forever" ]
then
  while [ 1 ]
  do
    compile
    sleep 0.2
  done
else
  compile
fi

