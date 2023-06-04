#!/bin/zsh

source ./.env

docker exec ${SCHEMA}-web sh /var/www/html/scripts/build.sh

