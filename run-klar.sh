#!/bin/bash

source ./env

while read image; do
  # Run on default image
  echo "Running klar on $LOCAL_REGISTRY/$image"
  CLAIR_ADDR=$CLAIR_ADDR FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.clair.log 2>&1
  CLAIR_ADDR=$CLAIR_ADDR FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$image > $LOGS/$image.clair.json 2>&1

  # Run on slimmed image
  imageslim=$image.slim
  echo "Running klar on $LOCAL_REGISTRY/$imageslim"
  CLAIR_ADDR=$CLAIR_ADDR FORMAT_OUTPUT=standard ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$image.clair.slim.log 2>&1
  CLAIR_ADDR=$CLAIR_ADDR FORMAT_OUTPUT=JSON ./klar $LOCAL_REGISTRY/$imageslim > $LOGS/$image.clair.slim.json 2>&1

done < $IMAGES_FILE
