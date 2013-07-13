var Viewport, device, win;

device = require('../core/device');

win = $(window);

Viewport = (function() {
  function Viewport(el, width, height) {
    this.el = el;
    this.width = width;
    this.height = height;
    this.scaleRatio = 0;
    this.x = 0;
    this.y = 0;
    this.fitInScreen();
    this.elWidth = this.el.width();
    this.elHeight = this.el.height();
    this.center();
  }

  Viewport.prototype.center = function() {
    var screen;

    screen = device.getSize();
    return this.moveTo((screen.width - this.elWidth) / 2, (screen.height - this.elHeight) / 2);
  };

  Viewport.prototype.fitInScreen = function() {
    var screen;

    screen = device.getSize();
    this.scaleRatio = this.width / screen.width;
    return this.el.css({
      width: this.width / this.scaleRatio,
      height: this.height / this.scaleRatio
    });
  };

  Viewport.prototype.moveTo = function(x, y, duration, callback, ease) {
    var newX, newY;

    if (duration == null) {
      duration = 0;
    }
    if (callback == null) {
      callback = null;
    }
    if (ease == null) {
      ease = false;
    }
    if (ease && !duration) {
      newX = this.x + (x - this.x) / 20;
      newY = this.y + (y - this.y) / 20;
      if ((Math.abs(this.x - newX)) < .1 && (Math.abs(this.y - newY)) < .1) {
        return;
      } else {
        this.x = newX;
        this.y = newY;
      }
    } else {
      if (this.x === x && this.y === y) {
        return;
      }
      this.x = x;
      this.y = y;
    }
    if (!duration) {
      return this.el.css({
        x: this.x,
        y: this.y
      });
    } else {
      return this.el.transition({
        x: this.x,
        y: this.y
      }, duration, callback);
    }
  };

  Viewport.prototype.worldToScreen = function(value) {
    if (typeof value === 'object' && (value.x != null) && (value.y != null)) {
      return {
        x: this.worldToScreen(value.x),
        y: this.worldToScreen(value.y)
      };
    } else {
      return value / this.scaleRatio;
    }
  };

  Viewport.prototype.screenToWorld = function(value) {
    if (typeof value === 'object' && (value.x != null) && (value.y != null)) {
      return {
        x: this.screenToWorld(value.x),
        y: this.screenToWorld(value.y)
      };
    } else {
      return value * this.scaleRatio;
    }
  };

  Viewport.prototype.fits = function() {
    var screen;

    screen = device.getSize();
    return this.elHeight <= screen.height;
  };

  Viewport.prototype.followEntity = function(target, duration, callback) {
    var margin, maskedSize, screen, targetPos, x, y;

    if (duration == null) {
      duration = 0;
    }
    if (callback == null) {
      callback = null;
    }
    targetPos = this.worldToScreen(target.position());
    maskedSize = {
      width: this.elWidth,
      height: this.elHeight
    };
    x = -targetPos.x + this.elWidth / 2;
    y = -targetPos.y + this.elHeight / 2;
    screen = device.getSize();
    if (maskedSize.height >= screen.height) {
      margin = maskedSize.height - screen.height;
      if (y > 0) {
        y = 0;
      } else if (y < -margin) {
        y = -margin;
      }
    }
    if (maskedSize.width >= screen.width) {
      margin = maskedSize.width - screen.width;
      if (x > 0) {
        x = 0;
      } else if (x < -margin) {
        x = -margin;
      }
    }
    return this.moveTo(x, y, duration, callback, true);
  };

  return Viewport;

})();

module.exports = Viewport;
