#!/bin/bash
source ./env

while read image; do 
echo "Pulling $image ... "
  docker pull $image
done < $IMAGES_FILE
