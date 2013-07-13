var debug, defaultDuration, device, flipViews, horizontalSlide, placeAbsolutely, popView, wrap;

device = require('./device');

debug = require('./debug');

defaultDuration = debug.skipAnimations ? 0 : 400;

wrap = $('#view-wrap');

placeAbsolutely = function(view) {
  var deviceSize;

  deviceSize = device.getSize();
  return view.elements.main.css({
    position: 'absolute',
    top: 0,
    left: 0,
    width: deviceSize.width,
    height: deviceSize.height
  });
};

popView = function(scaleFrom, newView, oldView, callback, duration) {
  if (duration == null) {
    duration = defaultDuration;
  }
  placeAbsolutely(newView);
  newView.elements.main.css({
    scale: scaleFrom,
    opacity: 0
  });
  newView.elements.main.transition({
    scale: 1,
    opacity: 1
  });
  return setTimeout(function() {
    return callback(newView);
  }, defaultDuration);
};

horizontalSlide = function(dir, newView, oldView, callback, duration) {
  var deviceSize;

  if (duration == null) {
    duration = defaultDuration;
  }
  deviceSize = device.getSize();
  wrap.css({
    width: deviceSize.width,
    'overflow-x': 'hidden',
    position: 'relative'
  });
  placeAbsolutely(newView);
  newView.elements.main.css({
    x: (100 * dir) + '%'
  });
  newView.elements.main.transition({
    x: '0'
  }, duration);
  if (oldView != null) {
    oldView.elements.main.css({
      width: deviceSize.width,
      height: deviceSize.height
    });
    return oldView.elements.main.transition({
      x: (100 * -dir) + '%'
    }, duration, function() {
      return callback(newView);
    });
  }
};

flipViews = function(newView, oldView, callback) {
  var duration;

  duration = defaultDuration;
  placeAbsolutely(newView);
  oldView.elements.main.css({
    position: 'relative',
    'z-index': 1
  });
  newView.elements.main.css({
    'z-index': -1,
    rotateY: '-90deg',
    z: -500
  });
  oldView.elements.main.transition({
    rotateY: '90deg'
  }, duration / 2);
  return setTimeout(function() {
    return newView.elements.main.transition({
      rotateY: '0deg'
    }, duration / 2);
  }, duration / 2, function() {
    return callback(newView);
  });
};

module.exports = {
  'slide-right': function(newView, oldView, callback) {
    return horizontalSlide(1, newView, oldView, callback);
  },
  'slide-left': function(newView, oldView, callback) {
    return horizontalSlide(-1, newView, oldView, callback);
  },
  'flip': flipViews,
  'pop-out': function(newView, oldView, callback) {
    return popView(2.2, newView, oldView, callback);
  },
  'pop-in': function(newView, oldView, callback) {
    return popView(.7, newView, oldView, callback);
  }
};
