#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsDirectoryExists

docker-compose ${OPTIONS} up -d zap-proxy remote-webdriver citizen-frontend legal-frontend

$(dirname "$0")/set-scanning-exclusions.sh
