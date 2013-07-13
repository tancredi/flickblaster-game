var BaseView, device, renderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

renderer = require('./renderer');

device = require('./device');

BaseView = (function() {
  function BaseView() {
    this.show = __bind(this.show, this);
    this.hide = __bind(this.hide, this);
    this.close = __bind(this.close, this);
    this.resize = __bind(this.resize, this);
    this.bind = __bind(this.bind, this);
    this.getElements = __bind(this.getElements, this);
    this.render = __bind(this.render, this);
  }

  BaseView.prototype.templateName = '';

  BaseView.prototype.fixHeight = false;

  BaseView.prototype.classNames = '';

  BaseView.prototype.context = {};

  BaseView.prototype.render = function(wrapper) {
    var rendered,
      _this = this;

    rendered = renderer.render("views/" + this.templateName, this.context);
    this.elements = {
      main: $("<div data-role='view' class='view " + this.classNames + "'>" + rendered + "</div>")
    };
    if (this.fixHeight) {
      this.elements.main.css({
        height: device.getSize().height
      });
    }
    this.getElements();
    if (wrapper != null) {
      this.elements.main.appendTo(wrapper);
    }
    this.resize();
    this.bind();
    $(window).on('resize', function() {
      return _this.resize();
    });
    return this;
  };

  BaseView.prototype.getElements = function() {};

  BaseView.prototype.bind = function() {};

  BaseView.prototype.resize = function() {};

  BaseView.prototype.close = function() {
    return this.elements.main.remove();
  };

  BaseView.prototype.hide = function() {
    return this.elements.main.hide();
  };

  BaseView.prototype.show = function() {
    this.elements.main.removeAttr('style');
    this.resize();
    return this.elements.main.show();
  };

  return BaseView;

})();

module.exports = BaseView;
