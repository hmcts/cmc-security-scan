#!/usr/bin/env bash

# Sanity & setup
if [[ ! -e 'integration-tests' ]]
then
  echo "Integration Tests not available, have you linked the directory? Check the README file for further details.\n"
  exit 123
fi

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml --project-directory ."

# Wait for ZAP Proxy to be available
ZAP_CONTAINER_ID="$(docker-compose ${OPTIONS} ps -q zap-proxy)"
RETRIES=0

until docker ps --filter "id=${ZAP_CONTAINER_ID}" --format '{{ .Status }}' | grep --quiet '(healthy)'
do
  echo "ZAP Proxy not healthy yet"
  sleep 10
  if [ ${RETRIES} -gt 10 ]
  then
    echo "ZAP Proxy container not healthy after reaching maximal retries, exiting"
    exit 1
  else
    RETRIES=$(($RETRIES+1))
  fi
done

# Exclude external domains from scanning
echo "Setting external domains scanning exclusions"

docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*www.payments.service.gov.uk.*'
docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*hmctspiwik.useconnect.co.uk.*'
docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*www.google-analytics.com.*'
docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*edgedl/chrome.*'
docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*authentication-web.*'
docker-compose ${OPTIONS} exec $@ zap-proxy zap-cli exclude '.*(js|img|stylesheets)/lib.*'
