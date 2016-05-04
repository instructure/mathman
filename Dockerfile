FROM instructure/node-passenger:4.3
MAINTAINER Instructure

WORKDIR /usr/src/app

USER root

COPY package.json package.json
RUN npm install --ignore-scripts --unsafe-perm

COPY nginx.conf /usr/src/nginx/conf.d/headers.conf

COPY . .

USER docker
