FROM instructure/node-passenger:18
MAINTAINER Instructure

USER root

RUN apt-get update && apt-get install -y --no-install-recommends zip \
  && rm -rf /var/lib/apt/lists/*

COPY package.json package.json
RUN npm install --ignore-scripts --unsafe-perm

COPY nginx.conf /usr/src/nginx/conf.d/headers.conf
COPY . .

USER docker
