#!/bin/bash
set -ex

PKG_SPEC=$1
CMD_NAME=$2
TAG_NAME=$3
LOCATION=$4

BASE_IMAGES=(
  'alpine:3.5'
  'alpine:3.6'
  'alpine:3.7'
  'alpine:3.8'
  'centos:6.6'
  'centos:6.7'
  'centos:6.8'
  'centos:6.9'
  'centos:6.10'
  'centos:7.1.1503'
  'centos:7.2.1511'
  'centos:7.3.1611'
  'centos:7.4.1708'
  'centos:7.5.1804'
  'debian:wheezy-slim'
  'debian:stretch-slim'
  'debian:jessie-slim'
  'debian:buster-slim'
  'debian:sid-slim'
  'fedora:26'
  'fedora:27'
  'fedora:28'
  'fedora:29'
  'ubuntu:14.04'
  'ubuntu:16.04'
  'ubuntu:18.04'
  'ubuntu:18.10'
)

# TODO {
#   alpine:3.1
#   alpine:3.2
#   alpine:3.3
#   alpine:3.4
#   cirros:0.4.0
#   clearlinux:latest
#   euleros:2.2
#   opensuse/tubleweed:latest
#   opensuse/leap:42.3
#   opensuse/leap:15.0
#   photon:1.0
#   photon:2.0
#  'ubuntu:12.04'
# }

function build {
  cp Dockerfile.$1 Dockerfile
  sed "s/{{BASE_IMG}}/${2}/" Dockerfile.$1 > Dockerfile

  TAG=$TAG_NAME:$(echo $2 | sed 's/:/-/')
  if [[ $LOCATION != '' ]]; then
    docker build \
      --build-arg CMD_NAME=$CMD_NAME \
      --build-arg PKG_SPEC=$PKG_SPEC \
      --build-arg LOCATION=$LOCATION \
      -t $TAG .
    else
      docker build \
        --build-arg CMD_NAME=$CMD_NAME \
        --build-arg PKG_SPEC=$PKG_SPEC \
        -t $TAG .
    fi

  rm Dockerfile

  #docker push $IMG
}

for img in "${BASE_IMAGES[@]}"; do
  if [[ $img = *"debian"* ]] || [[ $img = *"ubuntu"* ]]; then
    build debian $img
  elif [[ $img = *"centos"* ]] || [[ $img = *"fedora"* ]]; then
    build centos $img
  elif [[ $img = *"alpine"* ]]; then
    build alpine $img
  fi
done
