var GameControls, MouseControls, phys, renderer, style,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MouseControls = require('./MouseControls');

renderer = require('../core/renderer');

phys = require('../helpers/physics');

style = {
  lineCap: 'round',
  strokeStyle: '#db7c52',
  lineWidth: 5
};

GameControls = (function(_super) {
  __extends(GameControls, _super);

  function GameControls(game) {
    this.game = game;
    this.viewport = this.game.world.viewport;
    this.render();
    GameControls.__super__.constructor.call(this, this.game.elements.main);
  }

  GameControls.prototype.render = function() {
    var ctx;

    ctx = {
      width: this.viewport.elWidth,
      height: this.viewport.elHeight
    };
    this.canvas = $(renderer.render('game-controls', ctx));
    this.canvas.hide().appendTo(this.game.world.stage);
    this.ctx = this.canvas[0].getContext('2d');
    return $.extend(this.ctx, style);
  };

  GameControls.prototype.clearCanvas = function() {
    return this.ctx.clearRect(0, 0, this.viewport.elWidth, this.viewport.elHeight);
  };

  GameControls.prototype.hideCanvas = function() {
    return this.canvas.stop().fadeOut();
  };

  GameControls.prototype.showCanvas = function() {
    return this.canvas.stop().fadeIn();
  };

  GameControls.prototype.dragStart = function(e) {
    var entity, evt;

    GameControls.__super__.dragStart.apply(this, arguments);
    evt = this.getMouseEvent(e);
    entity = ($(evt.target)).data('entity');
    if ((entity != null) && entity.id === 'player') {
      this.showCanvas();
      this.flicking = true;
      return this.flickTarget = entity;
    }
  };

  GameControls.prototype.dragStop = function() {
    var center, dragged, vertex;

    GameControls.__super__.dragStop.apply(this, arguments);
    if (this.flicking) {
      center = this.viewport.worldToScreen(this.game.player.position());
      vertex = this.getRelativeMouse();
      dragged = {
        x: center.x - vertex.x,
        y: center.y - vertex.y
      };
      this.hideCanvas();
      this.clearCanvas();
      this.flickTarget.body.applyForce(dragged.x, dragged.y, 60);
      this.flicking = false;
      return this.flickTarget = null;
    }
  };

  GameControls.prototype.dragMove = function() {
    var center, vertex;

    this.clearCanvas();
    if (this.flicking) {
      center = this.viewport.worldToScreen(this.game.player.position());
      vertex = this.getRelativeMouse();
      this.ctx.beginPath();
      this.ctx.moveTo(center.x, center.y);
      this.ctx.lineTo(vertex.x, vertex.y);
      return this.ctx.stroke();
    }
  };

  return GameControls;

})(MouseControls);

module.exports = GameControls;
