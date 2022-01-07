#!/bin/bash

OUTDIR="issues"
URL_FILE="issues.txt"
MAGPI_DIR="magpi"
HACKSPACE_DIR="hackspace"
MAGPI_URL="https://magpi.raspberrypi.com/"
HACKSPACE_URL="https://hackspace.raspberrypi.com/"
MAGPI_LATEST=113
HACKSPACE_LATEST=50
ARIA_PARALLEL_DOWNLOADS=4

if [ ! -d "$OUTDIR" ]; then
  mkdir "$OUTDIR"
  mkdir "$OUTDIR/$MAGPI_DIR"
  mkdir "$OUTDIR/$HACKSPACE_DIR"
  touch "$OUTDIR/$MAGPI_DIR/$URL_FILE"
  touch "$OUTDIR/$HACKSPACE_DIR/$URL_FILE"
fi

clear

if [[ $(wc -l < "$OUTDIR/$MAGPI_DIR/$URL_FILE") -ne $MAGPI_LATEST ]]; then
  rm "$OUTDIR/$MAGPI_DIR/$URL_FILE"
  for i in $( seq 1 $MAGPI_LATEST )
  do
    URL=$(curl -s "${MAGPI_URL}issues/${i}/pdf/download/" | grep "c-link" | grep -o -P '(?<=href="/).*(?=">)')
    echo -ne "Writing URL for $MAGPI_DIR issue $i/$MAGPI_LATEST to $OUTDIR/$MAGPI_DIR/$URL_FILE...\\r"
    echo $MAGPI_URL$URL >> $OUTDIR/$MAGPI_DIR/$URL_FILE
  done
fi

clear

if [[ $(wc -l < "$OUTDIR/$HACKSPACE_DIR/$URL_FILE") -ne $HACKSPACE_LATEST ]]; then
  rm "$OUTDIR/$HACKSPACE_DIR/$URL_FILE"
  for i in $( seq 1 $HACKSPACE_LATEST )
  do
    URL=$(curl -s "${HACKSPACE_URL}issues/${i}/pdf/download/" | grep "c-link" | grep -o -P '(?<=href="/).*(?=">)' | tail -1)
    echo -ne "Writing URL for $HACKSPACE_DIR issue $i/$HACKSPACE_LATEST to $OUTDIR/$HACKSPACE_DIR/$URL_FILE...\\r"
    echo $HACKSPACE_URL$URL >> $OUTDIR/$HACKSPACE_DIR/$URL_FILE
  done
fi

clear

if [ "$OUTDIR/$MAGPI_DIR/$URL_FILE" ] && [ "$OUTDIR/$HACKSPACE_DIR/$URL_FILE" ]; then
  echo "Downloading $MAGPI_LATEST $MAGPI_DIR issues and $HACKSPACE_LATEST $HACKSPACE_DIR issues to $OUTDIR/..."
  if command -v aria2c &> /dev/null
  then
    aria2c -i "$OUTDIR/$MAGPI_DIR/$URL_FILE" \
      -j $ARIA_PARALLEL_DOWNLOADS \
      --dir "$OUTDIR/$MAGPI_DIR" \
      --continue=true \
      --keep-unfinished-download-result=false \
      --summary-interval=0 \
      --auto-file-renaming=false

    aria2c -i "$OUTDIR/$HACKSPACE_DIR/$URL_FILE" \
      -j $ARIA_PARALLEL_DOWNLOADS \
      --dir "$OUTDIR/$HACKSPACE_DIR" \
      --continue=true \
      --keep-unfinished-download-result=false \
      --summary-interval=0 \
      --auto-file-renaming=false
  else
    wget -nc -i "$OUTDIR/$MAGPI_DIR/$URL_FILE" -P "$OUTDIR/$MAGPI_DIR" -q --show-progress --progress=bar:force:noscroll

    wget -nc -i "$OUTDIR/$HACKSPACE_DIR/$URL_FILE" -P "$OUTDIR/$HACKSPACE_DIR" -q --show-progress --progress=bar:force:noscroll
  fi
fi

exit 0
