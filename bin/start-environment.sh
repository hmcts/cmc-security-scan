#!/bin/sh

if [[ ! -e 'integration-tests' ]]
then
  echo "Integration Tests not available, have you linked the directory? Check the README file for further details.\n"
  exit 123
fi

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml -f docker-compose-citizen.yml --project-directory ."

docker-compose ${OPTIONS} pull

docker-compose ${OPTIONS} up -d zap-proxy remote-webdriver citizen-frontend

$(dirname "$0")/set-scanning-exclusions.sh
