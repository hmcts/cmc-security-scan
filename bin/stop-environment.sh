#!/bin/sh

source $(dirname $0)/internal/common.sh
checkIntegrationTestsResourcesExists

docker-compose down ${@}
