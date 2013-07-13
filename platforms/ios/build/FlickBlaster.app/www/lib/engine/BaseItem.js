var BaseItem, defaults,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

defaults = {
  x: 0,
  y: 0
};

BaseItem = (function() {
  BaseItem.prototype.type = 'base';

  function BaseItem(options, layer) {
    this.layer = layer;
    this.update = __bind(this.update, this);
    this.moveTo = __bind(this.moveTo, this);
    this.translate = __bind(this.translate, this);
    options = $.extend(true, {}, defaults, options);
    this.x = options.x || 0;
    this.y = options.y || 0;
  }

  BaseItem.prototype.translate = function(x, y) {
    return this.moveTo(this.x + x, this.y + y);
  };

  BaseItem.prototype.moveTo = function(x, y) {
    this.x = x;
    return this.y = y;
  };

  BaseItem.prototype.update = function() {};

  return BaseItem;

})();

module.exports = BaseItem;
