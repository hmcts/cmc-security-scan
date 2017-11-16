#!/bin/sh

usage () {
  echo "Usage: $(dirname $0)/$(basename $0) <path-to-integration-tests>"
  exit
}

if [ "$#" -ne 1 ]
then
  usage
fi

ln -s $1/docker-compose.yml docker-compose.yml
ln -s $1/docker docker
