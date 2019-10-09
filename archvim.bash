#!/bin/bash

port=4242
image=archvim

archvim-build() {
  docker build --tag $image --build-arg proxy=$1 .
}

archvim-run() {
  docker run -d -p $port:22 $image
}

archvim-ssh() {
  ssh -p $port hoot@$1
}
