#!/bin/sh

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml --project-name $(basename $(pwd))"

checkIntegrationTestsDirectoryExists () {
  if [[ ! -e 'integration-tests' ]]
  then
    echo -e "Integration tests not available, have you linked the directory? Check the README file for further details.\n"
    exit 123
  fi
}
