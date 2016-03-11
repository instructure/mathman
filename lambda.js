'use strict';

let Typeset = require('./typeset');

let ts = new Typeset;

exports.handler = function(event, context, cb) {
  ts.typeset(event.tex, cb);
};
