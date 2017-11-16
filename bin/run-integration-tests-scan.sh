#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsResourcesExists

docker-compose up --no-deps integration-tests

if [ $? != 0 ]; then
  echo 'Integration tests failed'
  exit 1
fi

mkdir -p reports
docker-compose exec zap-proxy zap-cli report -o /zap/reports/zap-scan-report.html -f html
