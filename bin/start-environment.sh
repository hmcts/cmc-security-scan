#!/bin/sh

OPTIONS="-f integration-tests/docker-compose.yml -f docker-compose.yml -p security-scan"

docker-compose ${OPTIONS} up -d zap-proxy \
                                remote-webdriver \
                                citizen-frontend
