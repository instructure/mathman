'use strict';

let Typeset = require('./typeset');

let ts = new Typeset;

exports.handler = function(event, context, cb) {
  console.log('>>> exports.handler');
  console.log(event.tex);
  ts.typeset(event.tex, cb);
};
