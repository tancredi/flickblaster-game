var device, isMobile, isTouch, onResize, testSizes, touchEvents;

testSizes = {
  'galaxy-s3': [720, 1280, 2],
  'galaxy-s4': [1080, 1920, 3],
  'nexus-4': [768, 1280, 2],
  'iphone-4': [640, 920, 2],
  'iphone-5': [640, 1136, 2]
};

touchEvents = {
  click: "tap",
  mousedown: "touchstart",
  mousemove: "touchmove",
  mouseup: "touchend"
};

isMobile = window.navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/) ? true : false;

isTouch = (_.has(window, 'ontouchstart')) || (_.has(window, 'onmsgesturechange'));

device = {
  isTouch: isMobile,
  size: null,
  isTouch: isTouch
};

onResize = function() {
  return device.size = {
    width: $(window).innerWidth(),
    height: $(window).innerHeight()
  };
};

$(window).on('resize', onResize);

onResize();

module.exports = {
  isTouch: function() {
    return device.isTouch;
  },
  getSize: function() {
    if (typeof fakeSize !== "undefined" && fakeSize !== null) {
      return {
        width: fakeSize[0] / fakeSize[2],
        height: fakeSize[1] / fakeSize[2]
      };
    }
    return device.size;
  },
  getEvent: function(evtType) {
    if (device.isTouch && (_.has(touchEvents, evtType))) {
      return touchEvents[evtType];
    } else {
      return evtType;
    }
  },
  getCenter: function() {
    return {
      x: device.size.width / 2,
      y: device.size.height / 2
    };
  }
};
