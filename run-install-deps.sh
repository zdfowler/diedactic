#!/bin/bash

# Go get a version of docker slim
echo "Getting docker-slim binary and extracting it here..."
wget https://downloads.dockerslim.com/releases/1.30.0/dist_linux.tar.gz -O docker-slim.tar.gz
tar xvf docker-slim.tar.gz
mv dist_linux/* .
rmdir dist_linux
rm docker-slim.tar.gz
chmod +x docker-slim*
echo "docker-slim download complete."
echo ""

# Go get a version of klar
echo "Getting klar binary version 2.4.0 (Dec 2018)"
wget https://github.com/optiopay/klar/releases/download/v2.4.0/klar-2.4.0-linux-amd64 -O klar
chmod +x klar
echo "klar download complete"
echo ""
