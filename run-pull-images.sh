#!/bin/bash
IMAGES_FILE=images.list

while read image; do 
echo "Pulling $image ... "
  docker pull $image
done < $IMAGES_FILE
