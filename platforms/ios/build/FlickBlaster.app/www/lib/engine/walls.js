var Body, Wall, Walls, renderer, thickness;

Wall = require('./Wall');

Body = require('./Body');

renderer = require('../core/renderer');

thickness = 15;

Walls = (function() {
  function Walls(world) {
    this.world = world;
    this.width = this.world.viewport.width;
    this.height = this.world.viewport.height;
    this.render();
    this.walls = [];
    this.build();
    this.refresh();
  }

  Walls.prototype.render = function() {
    var ctx;

    ctx = {
      width: this.world.viewport.worldToScreen(this.width),
      height: this.world.viewport.worldToScreen(this.height)
    };
    this.wrap = $(renderer.render('game-walls', ctx));
    this.svg = this.wrap.find('svg');
    return this.wrap.appendTo(this.world.stage);
  };

  Walls.prototype.refresh = function() {
    this.wrap.html(this.wrap.html());
    return this.svg = this.wrap.find('svg');
  };

  Walls.prototype.add = function(options) {
    return this.walls.push(new Wall(options, this.world, this.svg));
  };

  Walls.prototype.build = function() {
    var dir, h, opposite, w, wall, walls, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _results;

    walls = [];
    _ref = ['x', 'y'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dir = _ref[_i];
      _ref1 = [false, true];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        opposite = _ref1[_j];
        if (dir === 'x') {
          w = this.width;
          h = thickness;
          x = this.width / 2;
          y = opposite ? this.height - thickness / 2 : thickness / 2;
        } else {
          w = thickness;
          h = this.height;
          x = opposite ? this.width - thickness / 2 : thickness / 2;
          y = this.height / 2;
        }
        walls.push({
          type: 'rect',
          x: x,
          y: y,
          width: w,
          height: h
        });
      }
    }
    _results = [];
    for (_k = 0, _len2 = walls.length; _k < _len2; _k++) {
      wall = walls[_k];
      _results.push(this.add(wall));
    }
    return _results;
  };

  return Walls;

})();

module.exports = Walls;
