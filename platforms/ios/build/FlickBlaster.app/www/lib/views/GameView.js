var BaseView, GameControls, GameView, World, device, getByRole, phys, win,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('../core/BaseView');

getByRole = require('../helpers/dom').getByRole;

device = require('../core/device');

phys = require('../helpers/physics');

World = require('../engine/World');

GameControls = require('../engine/GameControls');

win = $(window);

GameView = (function(_super) {
  __extends(GameView, _super);

  GameView.prototype.templateName = 'game';

  function GameView() {
    this.update = __bind(this.update, this);    GameView.__super__.constructor.apply(this, arguments);
  }

  GameView.prototype.getElements = function() {
    var screenSize;

    GameView.__super__.getElements.call(this);
    screenSize = device.getSize();
    return this.elements.main.css({
      overflow: 'hidden',
      width: screenSize.width,
      height: screenSize.height,
      position: 'relative',
      left: (win.width() - screenSize.width) / 2,
      top: (win.height() - screenSize.height) / 2
    });
  };

  GameView.prototype.bind = function() {
    var _this = this;

    GameView.__super__.bind.call(this);
    this.world = new World(this.elements.main, '01');
    return this.world.onReady(function() {
      return _this.startGame();
    });
  };

  GameView.prototype.startGame = function() {
    var _this = this;

    this.world.start();
    this.world.loop.play();
    this.target = this.world.getItemById('target');
    this.player = this.world.getItemById('player');
    this.player.onCollisionStart(this.target, function() {
      return console.log('Win!');
    });
    return this.showIntro(function() {
      _this.world.loop.use(_this.update);
      _this.controls = new GameControls(_this);
      return _this.controls.on();
    });
  };

  GameView.prototype.showIntro = function(callback) {
    var _this = this;

    this.viewportFits = this.world.viewport.fits();
    if (!this.viewportFits) {
      return this.world.viewport.followEntity(this.target, 1000, function() {
        return _this.world.viewport.followEntity(_this.player, 1000, function() {
          return callback();
        });
      });
    } else {
      return callback();
    }
  };

  GameView.prototype.update = function() {
    if (!this.viewportFits) {
      return this.world.viewport.followEntity(this.player);
    }
  };

  return GameView;

})(BaseView);

module.exports = GameView;
