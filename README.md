# MathMan by Instructure
## Introduction
This is a simple microservice that converts LaTeX formulae to MathML and SVG.
It can either be run locally via `docker-compose`, or on Amazon Lambda.

## Quick start (for Docker)
1. Install docker and docker-compose.
2. Run `cp docker-compose.dev.override.yml docker-compose.override.yml`
3. Run `docker-compose build`.
4. Run `docker-compose run --rm web npm install`.
5. Run `docker-compose up`.

This will launch the microservice, along with a Redis cache. The service
is available at `http://mathman.dev`.

The API interface is `/mml?tex=<tex-string>` or `svg?tex=<tex-string>`.

## Tests
1. Run `docker-compose build` if you haven't already.
2. Run `cp docker-compose.dev.override.yml docker-compose.override.yml`
3. Run `docker-compose run --rm web npm install`.
4. Run `docker-compose run --rm web npm test`.

## Deploy

### Full deploy

1. MathMan is hosted as an AWS lambda app with AWS API Gateway sitting in
  front of it. So, in order to deploy, you will need appropriate AWS
  credentials, and will have to have installed [AWS CLI] [1]. I did so
  with homebrew (`brew install awscli`) but there is an installer with the
  link above as well.

2. The AWS configuration is managed with [Terraform] [2], which will need
  to be installed as well. Similarly, homebrew is possible (`brew install
  terraform`) but there is also an installer at the provided link.

3. This repo assumes that the Terraform state is [managed remotely][3], and
   this needs to be [configured][4].

4. To just run a full deploy for a given environment, run `./deploy.sh
  <env_name>`. You will be shown the Terraform plan and asked to
  confirm before pushing to AWS. NOTE: this will fail if you skipped
  step 3.

[1]: https://aws.amazon.com/cli/
[2]: https://www.terraform.io/
[3]: https://www.terraform.io/docs/state/remote/index.html
[4]: https://www.terraform.io/docs/commands/remote-config.html


`deploy.sh` wraps 3 separate processes that can be run separately as
well.

### Package the code for lambda

1. Run `docker-compose run --rm web npm install`.
2. Run `docker-compose run --rm web ./deploy/package $(git rev-parse
   --short HEAD)`.

The result will be `build/lambda.zip` which can be uploaded to AWS as a
lambda function.

### Make a Terraform plan

In order to know what to do, Terraform needs a plan. The plan is
constructed based on the Terraform configuration file(s) in the
directory from which the `terraform plan` command is run.

In addition to the configuration files, Terraform uses state to track
what has been done previously. This repo assumes that state is managed
remotely. See step 3 above in the "Full Deploy" instructions for some
links about how to do this.

(The root configuration is found in `deploy/main.tf`.)

1. Run `cd deploy && make setup ENV=dev && make plan ENV=dev`.
2. Terraform will output the plan diff, and summarize what has changed /
   what has been added.

### Apply the Terraform plan

1. Run `cd deploy`.
2. Run `make setup ENV=dev`.
3. Run `make plan ENV=dev` (if you don't have a plan yet).
4. Run `make apply ENV=dev`.

Terraform will provide output indicating whether or not the application
was a success.

### Notes
This image is based on `instructure/node-passenger:4.3`, so most of the
configuration options for that container also apply to this one.
