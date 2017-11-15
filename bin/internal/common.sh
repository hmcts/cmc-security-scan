#!/bin/sh

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml --project-directory ."

checkIntegrationTestsDirectoryExists () {
  if [[ ! -e 'integration-tests' ]]
  then
    echo "Integration tests not available, have you linked the directory? Check the README file for further details.\n"
    exit 123
  fi
}
