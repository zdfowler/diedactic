#!/bin/bash

IMAGES_FILE=images.short.list
LOCAL_REGISTRY=registry.zdfowler.com:5443
LOGS=logs

while read image; do
  # Run on default image
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.std.log
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.json

  # Run on slimmed image
  imageslim=$image.slim
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$imageslim.std.log
  CLAIR_ADDR=localhost:6060 FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$imageslim.json

done < $IMAGES_FILE