#!/bin/bash

source ./env

while read image; do
  
  # docker-slim the image
  ./docker-slim --log $LOGS/$image.slim.log --report $LOGS/$image.slim.report.json build $image
done < $IMAGES_FILE
