#!/usr/bin/env bash

#get directory
DIR=$1

# improve contrast
contrast () {
  done=$(echo $1 | sed 's/.JPG/.contrast/g')
  convert $1 -sigmoidal-contrast 4,0% $done
}

# trim to text area
trim () {
  done=$(echo $1 | sed 's/.contrast/.trim/g')
  ./lib/autotrim.sh -f 50 $1 $done
}

# emphasize text
textclean () {
  done=$(echo $1 | sed 's/.trim/.clean/g')
  ./lib/textcleaner.sh -g -e stretch -f 25 -o 10 -u -s 1 -T -p 10 $1 $done
}

image_prep () {
  name=$(echo $1 | sed 's/.JPG//g')

  # if no contrast, contrast
  if [ ! -f "$name.contrast" ]; then
    contrast $1
  fi

  # if not trimed, trim
  if [ -f "$name.contrast" ]; then
    trim "$name.contrast"
  fi

  # if not cleaned, clean
  if [ -f "$name.trim" ]; then
    textclean "$name.trim"
  fi
}

# convert to pdf and run ocr
pdf_prep () {
  pdf=$(echo $1 | sed 's/.clean/.pdf/g')
  convert $1 $pdf
  pypdfocr $pdf
}

clean () {
  #clean up
  rm $1/*.cache
  rm $1/.contrast
  rm $1/.trim
  rm $1/.clean
}


main () {
  for f in $1/*; do
    #preprocess
    if [[ $f == *".JPG" ]]; then
      image_prep $f
    fi

    if [[ $f == *".clean" ]]; then
      pdf_prep $f
    fi
  done
}

main $DIR
