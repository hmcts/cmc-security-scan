#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsResourcesExists

docker-compose run --no-deps citizen-integration-tests
if [ $? != 0 ]; then
  echo 'Citizen integration tests failed'
  exit 1
fi

docker-compose run --no-deps legal-integration-tests
if [ $? != 0 ]; then
  echo 'Legal integration tests failed'
  exit 1
fi

mkdir -p reports
docker-compose exec zap-proxy zap-cli report -o /zap/reports/zap-scan-report.html -f html
