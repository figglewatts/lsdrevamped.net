#!/bin/bash
set -e

# run docker-compose from within a container, and alias docker-compose
# on the shell to run the container and forward the docker socket to the
# container
echo alias docker-compose="'"'docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:$PWD" \
    -w="$PWD" \
    docker/compose:1.24.0'"'" >> /etc/bash/bashrc