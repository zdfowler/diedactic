#!/bin/bash

IMAGES_FILE=images.list
LOCAL_REGISTRY=registry.zdfowler.com:5443


while read image; do
  # remove slim from local
  docker rmi $LOCAL_REGISTRY/$image.slim
  # remove slim from default
  docker rmi $image.slim
  # remove from local
  docker rmi $image
done < $IMAGES_FILE