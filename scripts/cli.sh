#!/usr/bin/env bash

docker run --name cli5 --rm -it \
 -v $PWD/root:/root \
 conjurinc/cli5:latest
