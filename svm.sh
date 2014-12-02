#!/bin/bash
#Script to run and train svm
# 2 args without flags

isScaled=false


# process inputs
if test $# -gt 2; then
  if [ "$1" = "-s" ]; then
    shift
    isScaled=true
  fi
fi

if [ ! \( -e $1 -a -e $2 \) ]
then
  echo Training or testing files do not exist! Aborting...
  exit 1
fi

if [ "$isScaled" = true ]; then
  echo scaling data
  svm-scale -l -1 -u 1 $1 > $1.temp
  svm-scale -l -1 -u 1 $2 > $2.temp
  rm $1 $2
  mv $1.temp $1
  mv $2.temp $2
fi

svm-train -qv $1 $1.model
svm-predict $2 $1.model $1.out
