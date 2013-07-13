var BaseItem, Sprite, SpriteRenderer, gameData,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseItem = require('./BaseItem');

SpriteRenderer = require('./SpriteRenderer');

gameData = require('./gameData');

Sprite = (function(_super) {
  __extends(Sprite, _super);

  Sprite.prototype.type = 'sprite';

  function Sprite(options, layer) {
    this.layer = layer;
    this.render = __bind(this.render, this);
    Sprite.__super__.constructor.apply(this, arguments);
    this.type = options.type;
    this.entity = options.entity || null;
    this.preset = gameData.get('sprites', this.type);
    this.viewport = this.layer.viewport;
    this.renderer = new SpriteRenderer(this.preset, this.viewport);
    this.render();
  }

  Sprite.prototype.render = function() {
    this.renderer.render();
    this.el = this.renderer.el;
    this.update();
    this.el.appendTo(this.layer.element);
    if (this.entity != null) {
      this.el.data('entity', this.entity);
    }
    return this.el.data('sprite', this);
  };

  Sprite.prototype.moveTo = function() {
    Sprite.__super__.moveTo.apply(this, arguments);
    return this.update();
  };

  Sprite.prototype.getAbsolutePosition = function() {
    var out, x, y;

    x = this.x;
    y = this.y;
    if (this.entity != null) {
      out = {
        x: this.entity.x - this.entity.offset.x + x,
        y: this.entity.y - this.entity.offset.y + y
      };
    } else {
      out = {
        x: x,
        y: y
      };
    }
    return this.viewport.worldToScreen(out);
  };

  Sprite.prototype.update = function(x, y) {
    var pos;

    pos = this.getAbsolutePosition();
    return this.el.css({
      x: pos.x - this.renderer.width / 2,
      y: pos.y - this.renderer.height / 2
    });
  };

  Sprite.prototype["export"] = function() {
    return {
      x: this.x,
      y: this.y,
      type: this.type
    };
  };

  return Sprite;

})(BaseItem);

module.exports = Sprite;
