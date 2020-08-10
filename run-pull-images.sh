#!/bin/bash
IMAGES_FILE=images.short.list

while read image; do 
echo "Pulling $image ... "
  docker pull $image
done < $IMAGES_FILE
