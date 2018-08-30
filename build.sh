#!/bin/bash
set -ex

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
  'ubuntu:16.10'
  'ubuntu:17.04'
  'ubuntu:17.10'
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

SPACK_VERSION="v0.11.2"

function build {
  cp Dockerfile.$1 Dockerfile
  sed -i "s/{{BASE_IMG}}/${2}/" Dockerfile

  TAG=${SPACK_VERSION}-$(echo $2 | sed 's/:/-/')
  IMG=ivotron/spack:$TAG
  docker build --build-arg SPACK_VERSION=$SPACK_VERSION -t $IMG .
  rm Dockerfile

  # test by installing a package
  docker run --rm $IMG install --show-log-on-error tree

  docker push $IMG
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
