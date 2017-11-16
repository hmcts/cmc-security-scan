#!/bin/sh

if [[ -z "${COMPOSE_PROJECT_NAME}" ]]; then
  export COMPOSE_PROJECT_NAME=$(basename $(pwd))
fi

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml"

checkIntegrationTestsDirectoryExists () {
  if [[ ! -e 'integration-tests' ]]
  then
    echo -e "Integration tests not available, have you linked the directory? Check the README file for further details.\n"
    exit 123
  fi
}
