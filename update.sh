#!/bin/bash

local=.
remote="root@192.168.7.2:~/TEST"
err=0

# example of using arguments to a script
lineargs1="-auz"
lineargs2="-e ssh --exclude .git --exclude .gitignore --progress --delete"
if [ "$1" == "push" ]; then
  src=$local
  dest=$remote
elif [ "$1" == "pull" ]; then
  src=$remote
  dest=$local
else
  echo "SYNTAX ERROR: expecting './update.sh push|pull nodry?'"
  err=1
fi

if [ $err -ne 1 ]; then
  if [ "$2" != "nodry" ]; then
    # dry run by default
    lineargs1=$lineargs1"vni"
  fi
  cmdargs="$lineargs1 $lineargs2 $src/ $dest"
  rsync $cmdargs
  echo "rsync $cmdargs"

fi
