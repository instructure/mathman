#!/bin/bash

ENVIRONMENT=$1
GIT_SHA=$(git rev-parse --short HEAD)

echo "ENVIRONMENT: $ENVIRONMENT"

docker-compose run -u 0 --rm web npm install && ./deploy/package $GIT_SHA

(cd deploy && make setup ENV=$ENVIRONMENT && make plan ENV=$ENVIRONMENT)

echo "Review the terraform plan, still want to deploy to $1?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) (cd deploy && make apply ENV=$ENVIRONMENT); break;;
    No ) exit;;
  esac
done
