#!/bin/sh

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml -p security-scan"

docker-compose ${OPTIONS} up --no-deps integration-tests

if [ $? != 0 ]; then
  echo 'Integration tests failed'
  exit 1
fi

mkdir -p reports
docker-compose ${OPTIONS} exec zap-proxy zap-cli report -o /zap/reports/integration-tests-scan.html -f html
