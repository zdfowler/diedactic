#!/bin/bash

source ./env

while read image; do
  # remove slim from local
  docker rmi $LOCAL_REGISTRY/$image.slim
  # remove slim from default
  docker rmi $image.slim
  # remove from local
  docker rmi $image
done < $IMAGES_FILE