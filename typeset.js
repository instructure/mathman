'use strict';

let mj = require("mathjax-node/lib/mj-single.js");

let calledStart = false;

class Typeset {
  constructor () {
    // only call start once, never more than that, or bad things happen.
    if (!calledStart) {
      mj.start();
      calledStart = true;
    }
  }

  typeset(tex, cb) {
    mj.typeset(
      {
        math: decodeURIComponent(tex),
        format: "inline-TeX",
        svg:true,
        mml: true,
        speakText: false,
        ex: 6,
        width: 100,
        linebreaks: true
      }, function (data) {
        if (!data.errors) {
          cb(null, {svg: data.svg, mml: data.mml});
        } else {
          cb(data.errors);
        }
      }
    );
  }
}

module.exports = Typeset;
