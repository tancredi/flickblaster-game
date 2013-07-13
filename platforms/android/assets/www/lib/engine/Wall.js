var Body, Wall, fill, renderer,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Body = require('./Body');

renderer = require('../core/renderer');

fill = '#a2bfc9';

Wall = (function(_super) {
  __extends(Wall, _super);

  Wall.prototype.itemType = 'wall';

  function Wall(options, world, svg) {
    this.world = world;
    this.svg = svg;
    options.interaction = 'static';
    Wall.__super__.constructor.apply(this, arguments);
    this.render();
  }

  Wall.prototype.render = function() {
    var ctx, point, x, y, _i, _len, _ref;

    ctx = {
      x: this.viewport.worldToScreen(this.x),
      y: this.viewport.worldToScreen(this.y),
      fill: fill
    };
    if (this.type === 'rect') {
      ctx.width = this.viewport.worldToScreen(this.width);
      ctx.height = this.viewport.worldToScreen(this.height);
      ctx.x -= ctx.width / 2;
      ctx.y -= ctx.height / 2;
    }
    if (this.type === 'circle') {
      ctx.radius = this.viewport.worldToScreen(this.radius);
    } else if (this.type === 'poly') {
      ctx.points = [];
      _ref = this.points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        x = (this.viewport.worldToScreen(point[0])) + ctx.x;
        y = (this.viewport.worldToScreen(point[1])) + ctx.y;
        ctx.points.push("" + x + "," + y);
      }
      ctx.points = ctx.points.join(' ');
    }
    this.el = $(renderer.render("svg-" + this.type, ctx));
    return this.el.appendTo(this.svg);
  };

  return Wall;

})(Body);

module.exports = Wall;
