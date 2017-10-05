#!/bin/sh

if [[ ! -e 'legal-integration-tests' ]]
then
  echo "Legal Integration tests not available, have you linked the directory? Check the README file for further details.\n"
  exit 123
fi

OPTIONS="-f legal-integration-tests/docker-compose.yml -f docker-compose.yml -f docker-compose-legal.yml --project-directory ."

docker-compose ${OPTIONS} up --no-deps legal-integration-tests

if [ $? != 0 ]; then
  echo 'Legal Integration tests failed'
  exit 1
fi

mkdir -p reports
docker-compose ${OPTIONS} exec zap-proxy zap-cli report -o /zap/reports/zap-scan-report-legal.html -f html
