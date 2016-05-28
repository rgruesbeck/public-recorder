#!/usr/bin/env bash

#get directory
DIR=$1

#contrast
for f in $1/*.JPG; do
    nf=$(echo $f | sed 's/IMG_/contrast-/g')
    echo contrast: $f
    convert $f -sigmoidal-contrast 4,0% $nf
done

#autotrim
for f in $1/contrast-*; do
    nf=$(echo $f | sed 's/contrast-/trim-/g')
    echo trim: $f
    ./autotrim.sh -f 50 $f $nf
done

#textcleaner
for f in $1/trim-*; do
    nf=$(echo $f | sed 's/trim-/clean-/g')
    echo clean: $f
    ./textcleaner.sh -g -e stretch -f 25 -o 10 -u -s 1 -T -p 10 $f $nf
done

#convert to .pdf
for f in $1/clean-*; do
    nf=$(echo $f | sed 's/clean-//g' | sed 's/.JPG/.pdf/g')
    echo pdf: $nf
    convert $f $nf
done

#compile pdf
pdfunite $1/*.pdf build.pdf

#run ocr
pypdfocr build.pdf

#orient to text: not implemented yet
pdfpextr () {
    # this function uses 3 arguments:
    #     $1 is the first page of the range to extract
    #     $2 is the last page of the range to extract
    #     $3 is the input file
    #     output file will be named "inputfile_pXX-pYY.pdf"
    gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
       -dFirstPage=${1} \
       -dLastPage=${2} \
       -sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
       ${3}
}

#clean up
ls $1
rm $1/*.cache
rm $1/contrast-*
rm $1/trim-*
rm $1/clean-*
rm $1/*.pdf
