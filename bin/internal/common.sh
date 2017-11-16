#!/bin/sh

checkIntegrationTestsResourcesExists () {
  if [[ ! -e 'docker-compose.yml' || ! -d 'docker' ]]; then
    echo -e "Integration tests resources are not available, have you linked the directory? Check the README file for further details.\n"
    exit 123
  fi
}
