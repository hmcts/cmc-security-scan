#!/bin/sh

if [[ ! -e 'integration-tests' ]]
then
  echo "Integration tests not available, have you linked the directory? Check the README file for further details.\n"
  exit 123
fi

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml --project-directory ."
SERVICE_URL='https://www-local.moneyclaim.reform.hmcts.net:3000'

mkdir -p reports
docker-compose ${OPTIONS} exec zap-proxy zap-cli open-url ${SERVICE_URL}
docker-compose ${OPTIONS} exec zap-proxy zap-cli active-scan --scanners all --recursive ${SERVICE_URL}
docker-compose ${OPTIONS} exec zap-proxy zap-cli report -o /zap/reports/active-scan.html -f html
