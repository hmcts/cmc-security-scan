#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsResourcesExists

docker-compose up -d zap-proxy remote-webdriver citizen-frontend legal-frontend

$(dirname $0)/set-scanning-exclusions.sh
