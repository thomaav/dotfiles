#!/bin/sh
set -e
cd ~/.getmail
rcfiles=""
for file in rc-* ; do
  rcfiles="$rcfiles --rcfile $file"
done
exec /usr/bin/getmail $rcfiles $@
