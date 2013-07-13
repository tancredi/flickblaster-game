var activeStateDuration, classNames, device, touchables;

device = require('../core/device');

touchables = 'a, .button, button, input, .touchable, .clickable';

classNames = {
  touchActive: 'touch-active'
};

activeStateDuration = 200;

module.exports = {
  initialise: function() {
    return this.bind();
  },
  bind: function() {
    var self;

    self = this;
    return $('body').on('click touchend', touchables, function() {
      return self.onClick($(this));
    });
  },
  onClick: function(element) {
    var _this = this;

    element.addClass(classNames.touchActive);
    return element.data('touchActiveTimer', setTimeout(function() {
      element.removeClass(classNames.touchActive);
      if (element.data('touchActiveTimer') != null) {
        return clearTimeout(element.data('touchActiveTimer'));
      }
    }, activeStateDuration));
  }
};
