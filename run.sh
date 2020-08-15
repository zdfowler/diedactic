#!/bin/bash

source ./env

# Run install deps first on your own

./run-pull-images.sh 
./run-slim-them.sh
./run-push-to-local-registry-orig-and-slim.sh
./run-klar.sh

# Create output data
./run-summarize-data.sh
