var BaseItem, Body, Entity, Sprite, gameData,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseItem = require('./BaseItem');

gameData = require('./gameData');

Sprite = require('./Sprite');

Body = require('./Body');

Entity = (function(_super) {
  __extends(Entity, _super);

  Entity.prototype.itemType = 'entity';

  function Entity(options, layer) {
    var preset;

    this.layer = layer;
    this.update = __bind(this.update, this);
    this.updatePos = __bind(this.updatePos, this);
    this.setPose = __bind(this.setPose, this);
    Entity.__super__.constructor.apply(this, arguments);
    if (options.preset) {
      preset = gameData.get('presets', options.preset);
      $.extend(options, preset);
    }
    this.attributes = options.attributes || null;
    this.id = options.id || null;
    this.offset = {
      x: 0,
      y: 0
    };
    this.body = null;
    this.makeBody(options.bodies);
    this.sprites = [];
    this.makeSprites(options.sprites);
  }

  Entity.prototype.makeSprites = function(sprites) {
    var options, sprite, _i, _len, _results;

    _results = [];
    for (_i = 0, _len = sprites.length; _i < _len; _i++) {
      sprite = sprites[_i];
      options = $.extend(true, {}, sprite, {
        entity: this
      });
      _results.push(this.sprites.push(new Sprite(options, this.layer)));
    }
    return _results;
  };

  Entity.prototype.hasAttr = function(attrName) {
    if (this.attributes == null) {
      return false;
    }
    return (this.attributes.indexOf(attrName)) !== -1;
  };

  Entity.prototype.makeBody = function(bodies) {
    var body, i, options, _i, _len, _results;

    _results = [];
    for (i = _i = 0, _len = bodies.length; _i < _len; i = ++_i) {
      body = bodies[i];
      options = $.extend(true, {}, body);
      options.x = this.x + body.x;
      options.y = this.y + body.y;
      if (i === 0) {
        this.offset = {
          x: body.x,
          y: body.y
        };
        this.body = new Body(options, this.layer.world);
        if (this.hasAttr('sensor')) {
          _results.push(this.body.setSensor(true));
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(this.body.addShape(options));
      }
    }
    return _results;
  };

  Entity.prototype.setPose = function(pose) {
    return this.sprite.pose = pose;
  };

  Entity.prototype.updatePos = function(x, y) {
    var sprite, _i, _len, _ref, _results;

    this.x = x;
    this.y = y;
    _ref = this.sprites;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sprite = _ref[_i];
      _results.push(sprite.update());
    }
    return _results;
  };

  Entity.prototype.update = function() {
    var bodyPos, sprite, _i, _len, _ref;

    _ref = this.sprites;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sprite = _ref[_i];
      sprite.update();
    }
    this.body.update();
    if (this.body != null) {
      bodyPos = this.body.position();
      if (this.x !== bodyPos.x || this.y !== bodyPos.y) {
        return this.updatePos(bodyPos.x, bodyPos.y);
      }
    }
  };

  Entity.prototype.position = function() {
    if (typeof this.body === "function" ? this.body(this.body.position()) : void 0) {

    } else {
      return {
        x: this.x,
        y: this.y
      };
    }
  };

  Entity.prototype.onCollision = function(target, callback) {
    return this.body.on('collision', target.body, callback);
  };

  Entity.prototype.onCollisionStart = function(target, callback) {
    return this.body.on('collisionstart', target.body, callback);
  };

  Entity.prototype.onCollision = function(target, callback) {
    return this.body.on('collisionstop', target.body, callback);
  };

  return Entity;

})(BaseItem);

module.exports = Entity;
