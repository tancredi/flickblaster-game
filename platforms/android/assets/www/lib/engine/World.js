var Layer, Loop, Viewport, Walls, World, debug, debugHelpers, defaults, device, gameData, phys, renderer;

gameData = require('./gameData');

Layer = require('./Layer');

device = require('../core/device');

renderer = require('../core/renderer');

debug = require('../core/debug');

debugHelpers = require('../helpers/debug');

phys = require('../helpers/physics');

Loop = require('./Loop');

Viewport = require('./Viewport');

Walls = require('./Walls');

defaults = {
  gravity: [0, 0]
};

World = (function() {
  function World(wrap, levelId, options) {
    var _this = this;

    this.wrap = wrap;
    if (options == null) {
      options = {};
    }
    this.ready = false;
    this.readyCallbacks = [];
    options = $.extend(true, {}, defaults, options);
    this.gravity = options.gravity;
    this.layers = {};
    this.stage = ($(renderer.render('game-stage'))).appendTo(this.wrap);
    this.loop = new Loop;
    this.initPhysics();
    this.loadLevel(levelId);
    this.onReady(function() {
      return _this.start;
    });
  }

  World.prototype.initPhysics = function() {
    var _this = this;

    this.gravity = new phys.Vector(this.gravity[0], this.gravity[1]);
    this.b2dWorld = new phys.World(this.gravity, true);
    return window.setInterval(function() {
      _this.b2dWorld.Step(1 / 60, 10, 10);
      return _this.b2dWorld.ClearForces();
    }, 1000 / 60);
  };

  World.prototype.onReady = function(callback) {
    if (this.ready) {
      return callback();
    } else {
      return this.readyCallbacks.push(callback);
    }
  };

  World.prototype.loadLevel = function(levelId, callback) {
    var _this = this;

    return gameData.loadLevel(levelId, function(level) {
      var body, cb, entity, layer, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2, _results;

      _this.level = level;
      _this.viewport = new Viewport(_this.stage, _this.level.size[0], _this.level.size[1]);
      layer = _this.addLayer('entities', 'entity');
      _ref = (_this.loadLayerData('entities')).items;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        layer.add(entity);
      }
      _this.walls = new Walls(_this);
      _ref1 = (_this.loadLayerData('walls')).items;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        body = _ref1[_j];
        _this.walls.add(body);
      }
      _this.walls.refresh();
      _this.ready = true;
      _ref2 = _this.readyCallbacks;
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        cb = _ref2[_k];
        _results.push(cb());
      }
      return _results;
    });
  };

  World.prototype.loadLayerData = function(layerId) {
    var layer, _i, _len, _ref;

    if (layerId != null) {
      _ref = this.level.layers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        layer = _ref[_i];
        if (layer.id === layerId) {
          return layer;
        }
      }
    }
    return null;
  };

  World.prototype.addLayer = function(id, type) {
    return this.layers[id] = new Layer(this, type, id);
  };

  World.prototype.getLayerById = function(layerId) {
    if (this.layers[layerId]) {
      return this.layers[layerId];
    }
    return null;
  };

  World.prototype.addBody = function(body) {
    return this.b2dWorld.CreateBody(body.bodyDef).CreateFixture(body.fixtureDef);
  };

  World.prototype.getItemById = function(id) {
    var item, layer, layerId, _i, _len, _ref, _ref1;

    _ref = this.layers;
    for (layerId in _ref) {
      layer = _ref[layerId];
      _ref1 = layer.items;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        item = _ref1[_i];
        if (item.id === id) {
          return item;
        }
      }
    }
    return null;
  };

  World.prototype.start = function() {
    var _this = this;

    this.loop.use(function() {
      return _this.update();
    });
    if (debug.debugPhysics) {
      return debugHelpers.initPhysicsDebugger(this);
    }
  };

  World.prototype.update = function() {
    var layer, layerId, _ref, _results;

    _ref = this.layers;
    _results = [];
    for (layerId in _ref) {
      layer = _ref[layerId];
      _results.push(layer.update());
    }
    return _results;
  };

  return World;

})();

module.exports = World;
