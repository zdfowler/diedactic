#!/bin/bash

IMAGES_FILE=images.list
LOCAL_REGISTRY=registry.zdfowler.com:5443


while read image; do
  
  # docker-slim the image
  ./docker-slim build $image
done < $IMAGES_FILE