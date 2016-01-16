#!/bin/sh

for file in `ls *.jhf`; do
    outfile=../giza-hershey_fonts-`basename $file | cut -d. -f1`.ads
    echo "convert " $file " into " $outfile
    python hersheyparse.py $file > $outfile
done
