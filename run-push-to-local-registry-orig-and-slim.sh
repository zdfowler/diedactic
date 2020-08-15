#!/bin/bash

source ./env

while read image; do
  
  # tag and push into local repo for analyzing
  echo "Tagging $image to local registry $LOCAL_REGISTRY/$image"
  docker tag $image $LOCAL_REGISTRY/$image
  docker push $LOCAL_REGISTRY/$image

  # tag and push into local repo for analyzing
  echo "Tagging $image.slim to local registry $LOCAL_REGISTRY/$image.slim"
  docker tag $image.slim $LOCAL_REGISTRY/$image.slim
  docker push $LOCAL_REGISTRY/$image.slim

done < $IMAGES_FILE
