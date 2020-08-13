#!/bin/bash

IMAGES_FILE=images.list
LOCAL_REGISTRY=registry.zdfowler.com:5443
LOGS=logs

while read image; do
  # Run on default image
  echo "Running klar on $LOCAL_REGISTRY/$image"
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.std.log
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.json

  # Run on slimmed image
  imageslim=$image.slim
  echo "Running klar on $LOCAL_REGISTRY/$imageslim"
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$imageslim.std.log
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$imageslim.json

done < $IMAGES_FILE
