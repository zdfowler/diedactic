# diedactic
Docker Image Evaluation with Docker-slim And Clair To Identify CVEs

## Overview

This tool measures the security performance of `docker-slim` by analyzing pre- and post- "slimmed" images for CVE counts via `clair`.  Given a list of images, this tool will fetch the images into a private registry for analysis.  

## Software Requirements

- Docker-slim - https://github.com/docker-slim/docker-slim - binary preferred over running as a containerized command
- Klar - https://github.com/optiopay/klar - client runner for Clair (binary)

Install these binaries in the project root directory by running `run-install-deps.sh`

## Hardware Requirements

- Disk space equivalent to store images in private registry

## Environment Setup

The file `images.list` contains a list of images to analyze, one per line.  

The `certs/` directory contains a custom CA certificate and registry certificiate (with associated private key) signed by the custom CA to allow proper TLS connections between `clair` and the private registry.

The scripts used here assume the following ports are open on localhost:

- 5000 and 5443 for local docker registry
- 6060 and 6061 for clair services

## USAGE

The `run-*` scripts are separated by task, though each uses the `images.list` file as a driver, looping over each image name.  

To analyze images, first install dependencies:

1. `./docker-compose up` - Starts `clair` service and private registry (Use separate terminal without `-d` to monitor log output)
1. `./run-install-deps.sh` - Downloads `docker-slim` and `klar` binaries


Create or fill the `images.list` file with at least one image name, one per line.

> `images.list`

Once the dependencies are installed, use the runner script to do everything at once.

> `./run.sh`

Alternatively, run each step as its own command:

1. `./run-pull-images.sh` - Pulls images down from registry
1. `./run-slim-them.sh` - Runs `docker-slim build $image` to create slimmed image, tagged as `$image.slim`
1. `./run-push-to-local-registry-slimmed.sh` - Pushes images and their slimmed copy into the private registry for `clair` access
1. `./run-klar.sh` - For every image in `images.list` and its paired `.slim` image, scan the image for CVEs


