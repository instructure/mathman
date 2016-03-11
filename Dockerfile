FROM instructure/node-passenger:4.3
MAINTAINER Instructure
WORKDIR /usr/src/app
COPY package.json /usr/src/app/package.json
RUN npm install
COPY nginx.conf /usr/src/nginx/conf.d/headers.conf
COPY typeset.js /usr/src/app/typeset.js
COPY server.js /usr/src/app/app.js
