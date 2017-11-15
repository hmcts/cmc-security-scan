#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsDirectoryExists

docker-compose ${OPTIONS} pull
