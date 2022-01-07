#!/bin/bash

OUTDIR="issues"
URL_FILE="issues.txt"
BASEURL="https://magpi.raspberrypi.com/"
LATEST=113

if [ ! -d "$OUTDIR" ]; then
  mkdir "$OUTDIR"
  touch "$OUTDIR/$URL_FILE"
fi

clear

if [[ $(wc -l < "$OUTDIR/$URL_FILE") -gt $LATEST ]]; then
  rm "$OUTDIR/$URL_FILE"
  for i in $( seq 1 $LATEST )
  do
    URL=$(curl -s "${BASEURL}issues/${i}/pdf/download/" | grep "c-link" | grep -o -P '(?<=href="/).*(?=">)')
    echo -ne "Writing URL for issue $i/$LATEST to $OUTDIR/$URL_FILE...\\r"
    echo ${BASEURL}$URL >> $OUTDIR/$URL_FILE
  done
fi

clear

if [ "$OUTDIR/$URL_FILE" ]; then
  echo "Downloading $LATEST issues to $OUTDIR/$URL_FILE..."
  if command -v aria2c &> /dev/null
  then
    aria2c -i $OUTDIR/$URL_FILE \
      -j 4 \
      --dir $OUTDIR \
      --continue=true \
      --keep-unfinished-download-result=false \
      --summary-interval=0 \
      --auto-file-renaming=false
  else
    wget -nc -i "$OUTDIR/$URL_FILE" -P $OUTDIR -q --show-progress --progress=bar:force:noscroll
  fi
fi

exit 0
