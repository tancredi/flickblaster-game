var Loop, requestAnimationFrame,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
  return window.setTimeout(callback, 1000 / 60);
};

Loop = (function() {
  function Loop() {
    this.getFPS = __bind(this.getFPS, this);
    this.next = __bind(this.next, this);
    this.use = __bind(this.use, this);
    this.pause = __bind(this.pause, this);
    this.play = __bind(this.play, this);    this.callbacks = [];
    this.playing = false;
    this.fps = 0;
  }

  Loop.prototype.play = function() {
    this.playing = true;
    return requestAnimationFrame(this.next);
  };

  Loop.prototype.pause = function() {
    return this.playing = false;
  };

  Loop.prototype.use = function(callback) {
    return this.callbacks.push(callback);
  };

  Loop.prototype.next = function() {
    var callback, _i, _len, _ref;

    this.getFPS();
    _ref = this.callbacks;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      callback();
    }
    if (this.playing) {
      return requestAnimationFrame(this.next);
    }
  };

  Loop.prototype.getFPS = function() {
    var delta;

    if (!this.lastUpdate) {
      this.lastUpdate = new Date().getTime();
    }
    delta = (new Date().getTime() - this.lastCalledTime) / 1000;
    this.lastCalledTime = new Date().getTime();
    return this.fps = 1 / delta;
  };

  return Loop;

})();

module.exports = Loop;
