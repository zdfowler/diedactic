#!/bin/bash

IMAGES_FILE=images.list
LOCAL_REGISTRY=registry.zdfowler.com:5443


while read image; do
  
  # tag and push into local repo for analyzing
  docker tag $image $LOCAL_REGISTRY/$image
  docker push $LOCAL_REGISTRY/$image

  # tag and push into local repo for analyzing
  docker tag $image.slim $LOCAL_REGISTRY/$image.slim
  docker push $LOCAL_REGISTRY/$image.slim

done < $IMAGES_FILE
