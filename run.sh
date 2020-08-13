#!/bin/bash

source ./env

# Run install deps first on your own

./run-pull-images.sh 
./run-slim-them.sh
./run-push-to-local-registry.sh
./run-klar.sh
