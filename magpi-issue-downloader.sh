#!/bin/bash

OUTDIR="issues"
BASEURL="https://magpi.raspberrypi.org/"
LATEST=104

if [ ! -d "$OUTDIR" ]; then
  mkdir "$OUTDIR"
fi

clear

for i in $( seq 1 $LATEST )
do
  URL=$(curl -s "${BASEURL}issues/${i}/pdf/download/" | grep "c-link" | grep -o -P '(?<=href="/).*(?=">)')
  wget -nc $BASEURL$URL -P $OUTDIR -q --show-progress --progress=bar:force:noscroll
  clear
done

exit 0
