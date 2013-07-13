var BaseItem, Body, phys,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseItem = require('./BaseItem');

phys = require('../helpers/physics');

Body = (function(_super) {
  __extends(Body, _super);

  Body.prototype.itemType = 'body';

  function Body(options, world) {
    var i, _i, _ref;

    this.world = world;
    Body.__super__.constructor.apply(this, arguments);
    this.type = options.type;
    this.viewport = this.world.viewport;
    this.touchListeners = [];
    if (this.type === 'circle') {
      this.radius = options.radius;
    } else if (this.type === 'rect') {
      this.width = options.width;
      this.height = options.height;
    } else if (this.type === 'poly') {
      this.points = [];
      for (i = _i = 0, _ref = options.points.length / 2; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.points.push([options.points[i * 2], options.points[i * 2 + 1]]);
      }
    } else {
      return;
    }
    this.b2dBody = this.world.addBody(phys.getBody(this.getBodyOptions(options)));
  }

  Body.prototype.getBodyOptions = function(options) {
    var out, point, x, y, _i, _len, _ref, _ref1;

    out = {
      type: options.type,
      interaction: (_ref = options.interaction) != null ? _ref : true
    };
    if ((options.x != null) && (options.y != null)) {
      out.x = this.viewport.worldToScreen(options.x);
      out.y = this.viewport.worldToScreen(options.y);
    }
    if (options.radius != null) {
      out.radius = this.viewport.worldToScreen(options.radius);
    }
    if ((options.width != null) && (options.height != null)) {
      out.width = this.viewport.worldToScreen(options.width);
      out.height = this.viewport.worldToScreen(options.height);
    }
    if (options.points != null) {
      out.points = [];
      _ref1 = this.points;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        point = _ref1[_i];
        x = this.viewport.worldToScreen(point[0]);
        y = this.viewport.worldToScreen(point[1]);
        out.points.push([x, y]);
      }
    }
    return out;
  };

  Body.prototype.addShape = function(options) {
    var body, pos;

    options = this.getBodyOptions(options);
    body = phys.getBody(options);
    pos = this.viewport.worldToScreen(this.position());
    body.fixtureDef.shape.m_p.x = (options.x - pos.x) / 30;
    body.fixtureDef.shape.m_p.y = (options.y - pos.y) / 30;
    return this.b2dBody.m_body.CreateFixture(body.fixtureDef);
  };

  Body.prototype.applyForce = function(x, y, multiplier) {
    var point, vector;

    if (multiplier == null) {
      multiplier = 0;
    }
    point = this.b2dBody.m_body.GetWorldCenter();
    x = (this.viewport.worldToScreen(x)) * multiplier;
    y = (this.viewport.worldToScreen(y)) * multiplier;
    vector = phys.getVector(x, y);
    return this.b2dBody.m_body.ApplyForce(vector, point);
  };

  Body.prototype.position = function() {
    return this.viewport.screenToWorld(phys.getBodyPosition(this.b2dBody));
  };

  Body.prototype.setSensor = function(state) {
    return this.b2dBody.SetSensor(state);
  };

  Body.prototype.update = function() {
    var contact, listener, _i, _len, _ref, _results;

    _ref = this.touchListeners;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      listener = _ref[_i];
      contact = this.b2dBody.m_body.GetContactList();
      if (contact != null) {
        if (contact.other === listener.body) {
          if (listener.colliding && listener.evt === 'collision') {
            _results.push(callback());
          } else if (!listener.colliding) {
            listener.colliding = true;
            if (listener.evt === 'collisionstart') {
              _results.push(listener.callback());
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        } else if (listener.colliding) {
          listener.colliding = false;
          if (listener.evt === 'collisionstop') {
            _results.push(listener.callback());
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Body.prototype.on = function(evt, target, callback) {
    return this.touchListeners.push({
      target: target,
      evt: evt,
      body: target.b2dBody.m_body,
      callback: callback,
      colliding: false
    });
  };

  return Body;

})(BaseItem);

module.exports = Body;
