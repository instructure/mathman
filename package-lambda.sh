#!/bin/bash
rm lambda.zip
npm install mathjax-node@^0.5.1
zip -9rq lambda.zip typeset.js lambda.js node_modules