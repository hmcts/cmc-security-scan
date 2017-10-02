#!/bin/sh

if [[ ! -e 'legal-integration-tests' ]]
then
  echo "Legal Integration Tests not available, have you linked the directory? Check the README file for further details.\n"
  exit 123
fi

OPTIONS="-f legal-integration-tests/docker-compose.yml -f docker-compose.yml --project-directory ."

docker-compose ${OPTIONS} down ${@}