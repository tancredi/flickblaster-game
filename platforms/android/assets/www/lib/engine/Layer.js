var Entity, Layer, device, renderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Entity = require('./Entity');

renderer = require('../core/renderer');

device = require('../core/device');

Layer = (function() {
  function Layer(world, itemsType, id) {
    this.world = world;
    this.itemsType = itemsType;
    this.id = id;
    this.update = __bind(this.update, this);
    this.add = __bind(this.add, this);
    this.viewport = this.world.viewport;
    this.element = $(renderer.render('game-layer'));
    this.element.appendTo(this.viewport.el);
    this.idIncr = 0;
    this.items = [];
    this.groups = {};
  }

  Layer.prototype.add = function(options) {
    var item;

    if (this.itemsType === 'entity') {
      item = new Entity(options, this);
    } else {
      return;
    }
    this.items.push(item);
    if (item.group != null) {
      if (!_.has(this.groups, entity.group)) {
        this.groups[entity.group] = [];
      }
      return this.groups[entity.group].push(entity);
    }
  };

  Layer.prototype.update = function() {
    var item, _i, _len, _ref, _results;

    _ref = this.items;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      _results.push(item.update());
    }
    return _results;
  };

  return Layer;

})();

module.exports = Layer;
