;(function(e,t,n){function i(n,s){if(!t[n]){if(!e[n]){var o=typeof require=="function"&&require;if(!s&&o)return o(n,!0);if(r)return r(n,!0);throw new Error("Cannot find module '"+n+"'")}var u=t[n]={exports:{}};e[n][0](function(t){var r=e[n][1][t];return i(r?r:t)},u,u.exports)}return t[n].exports}var r=typeof require=="function"&&require;for(var s=0;s<n.length;s++)i(n[s]);return i})({1:[function(require,module,exports){
var bind, device, gameData, init, onDeviceReady, renderer, touchables, views;

device = require('./core/device');

renderer = require('./core/renderer');

views = require('./core/views');

gameData = require('./engine/gameData');

touchables = require('./ui/touchables');

views.load({
  home: require('./views/HomeView'),
  game: require('./views/GameView')
});

renderer.templates = window.templates;

init = function() {
  if (device.isTouch()) {
    return bind();
  } else {
    return onDeviceReady();
  }
};

bind = function() {
  return document.addEventListener('deviceready', onDeviceReady, false);
};

onDeviceReady = function() {};

touchables.initialise();

gameData.init();

gameData.onReady(function() {
  return views.open('game');
});

init();

},{"./core/device":2,"./core/renderer":3,"./core/views":4,"./engine/gameData":5,"./ui/touchables":6,"./views/HomeView":7,"./views/GameView":8}],2:[function(require,module,exports){
var device, isMobile, isTouch, onResize, testSizes, touchEvents;

testSizes = {
  'galaxy-s3': [720, 1280, 2],
  'galaxy-s4': [1080, 1920, 3],
  'nexus-4': [768, 1280, 2],
  'iphone-4': [640, 920, 2],
  'iphone-5': [640, 1136, 2]
};

touchEvents = {
  click: "tap",
  mousedown: "touchstart",
  mousemove: "touchmove",
  mouseup: "touchend"
};

isMobile = window.navigator.userAgent.match(/(iPhone|iPod|iPad|Android|BlackBerry)/) ? true : false;

isTouch = (_.has(window, 'ontouchstart')) || (_.has(window, 'onmsgesturechange'));

device = {
  isTouch: isMobile,
  size: null,
  isTouch: isTouch
};

onResize = function() {
  return device.size = {
    width: $(window).innerWidth(),
    height: $(window).innerHeight()
  };
};

$(window).on('resize', onResize);

onResize();

module.exports = {
  isTouch: function() {
    return device.isTouch;
  },
  getSize: function() {
    if (typeof fakeSize !== "undefined" && fakeSize !== null) {
      return {
        width: fakeSize[0] / fakeSize[2],
        height: fakeSize[1] / fakeSize[2]
      };
    }
    return device.size;
  },
  getEvent: function(evtType) {
    if (device.isTouch && (_.has(touchEvents, evtType))) {
      return touchEvents[evtType];
    } else {
      return evtType;
    }
  },
  getCenter: function() {
    return {
      x: device.size.width / 2,
      y: device.size.height / 2
    };
  }
};

},{}],3:[function(require,module,exports){
module.exports = {
  templates: {},
  compile: function(tpl) {
    if (typeof template === 'function') {
      return tpl;
    } else {
      return Handlebars.compile(tpl);
    }
  },
  set: function(id, template) {
    return this.templates[id] = typeof template === 'string' ? this.compile(template) : template;
  },
  get: function(nsString) {
    if (nsString == null) {
      nsString = null;
    }
    if (nsString != null) {
      return this.templates[nsString];
    } else {
      return this.templates;
    }
  },
  render: function(id, data) {
    if (this.get(id) != null) {
      return this.get(id)(data);
    } else {
      throw "Template '" + id + "' not found";
    }
  }
};

},{}],5:[function(require,module,exports){
var baseDir, gameData, ready, readyCallbacks;

baseDir = 'game/';

gameData = {
  sprites: {},
  materials: {},
  levels: {}
};

ready = false;

readyCallbacks = [];

module.exports = {
  init: function() {
    return this.loadData(['sprites', 'materials', 'presets'], function() {
      var cb, _i, _len, _results;

      ready = true;
      _results = [];
      for (_i = 0, _len = readyCallbacks.length; _i < _len; _i++) {
        cb = readyCallbacks[_i];
        _results.push(cb());
      }
      return _results;
    });
  },
  get: function(type, id) {
    if (!_.has(gameData, type)) {
      throw "GameData error: No data for '" + type + "'";
    }
    if (!_.has(gameData[type], id)) {
      throw "GameData error: '" + type + "' does not contain '" + id + "'";
    }
    return gameData[type][id];
  },
  onReady: function(cb) {
    if (ready) {
      return cb();
    } else {
      return readyCallbacks.push(cb);
    }
  },
  loadLevel: function(id, callback) {
    return $.getJSON("" + baseDir + "levels/" + id + ".json", function(level) {
      if (typeof callback === 'function') {
        return callback(level);
      }
    }).fail(function(req, err) {
      throw "Error loading level: " + id + ".json - " + err;
    });
  },
  loadData: function(nsArr, callback) {
    var loaded, ns, _i, _len, _results,
      _this = this;

    loaded = 0;
    _results = [];
    for (_i = 0, _len = nsArr.length; _i < _len; _i++) {
      ns = nsArr[_i];
      _results.push((function(ns) {
        return $.getJSON("" + baseDir + ns + ".json", function(data) {
          gameData[ns] = data;
          loaded++;
          if (loaded === nsArr.length && typeof callback === 'function') {
            return callback(data);
          }
        }).fail(function(req, err) {
          throw "Error loading game data: " + ns + ".json - " + err;
        });
      })(ns));
    }
    return _results;
  }
};

},{}],4:[function(require,module,exports){
var getByRole, renderer, transitions;

renderer = require('./renderer');

getByRole = require('../helpers/dom').getByRole;

transitions = require('./viewTransitions');

module.exports = {
  wrap: $('#view-wrap'),
  current: null,
  shown: [],
  views: {},
  closeAll: function() {
    return getByRole('view', this.wrap).remove();
  },
  load: function(ns, view) {
    var routes, _results;

    if (typeof ns === 'object') {
      routes = ns;
      _results = [];
      for (ns in routes) {
        view = routes[ns];
        _results.push(this.load(ns, view));
      }
      return _results;
    } else {
      return this.views[ns] = view;
    }
  },
  open: function(ns, transition, callback, openOnTop, options) {
    var view;

    if (transition == null) {
      transition = null;
    }
    if (callback == null) {
      callback = null;
    }
    if (openOnTop == null) {
      openOnTop = false;
    }
    if (options == null) {
      options = {};
    }
    if (!openOnTop) {
      this.shown = [];
    }
    if ((transition != null) && this.animating) {
      return false;
    }
    if (typeof ns === 'object') {
      view = ns;
    } else {
      view = new this.views[ns](options);
    }
    if (view.elements == null) {
      view.render(this.wrap);
    } else {
      view.show();
    }
    if ((transition != null) && _.has(this.transitions, transition)) {
      this.applyTransition(view, transition, callback, openOnTop);
    } else {
      this.onShown(view, callback, openOnTop);
    }
    return view;
  },
  applyTransition: function(view, transition, callback, openOnTop) {
    var newViewStyle, oldViewStyle,
      _this = this;

    if (callback == null) {
      callback = null;
    }
    if (openOnTop == null) {
      openOnTop = false;
    }
    this.animating = true;
    oldViewStyle = this.current.elements.main.attr('style');
    newViewStyle = view.elements.main.attr('style');
    return this.transitions[transition](view, this.current, function() {
      _this.animating = false;
      _this.onShown(view, callback, openOnTop);
      _this.current.elements.main.stop();
      view.elements.main.stop();
      if (oldViewStyle) {
        _this.current.elements.main.attr('style', oldViewStyle);
      } else {
        _this.current.elements.main.removeAttr('style');
      }
      if (newViewStyle) {
        view.elements.main.attr('style', newViewStyle);
      } else {
        view.elements.main.removeAttr('style');
      }
      return _this.wrap.removeAttr('style');
    });
  },
  onShown: function(view, callback, openOnTop) {
    if (callback == null) {
      callback = null;
    }
    if (openOnTop == null) {
      openOnTop = false;
    }
    if (!openOnTop) {
      if (this.current != null) {
        this.current.close();
      }
    } else {
      this.current.hide();
    }
    this.shown.push(view);
    this.current = view;
    if (callback != null) {
      return callback(view);
    }
  },
  transitions: transitions
};

},{"./renderer":3,"../helpers/dom":9,"./viewTransitions":10}],6:[function(require,module,exports){
var activeStateDuration, classNames, device, touchables;

device = require('../core/device');

touchables = 'a, .button, button, input, .touchable, .clickable';

classNames = {
  touchActive: 'touch-active'
};

activeStateDuration = 200;

module.exports = {
  initialise: function() {
    return this.bind();
  },
  bind: function() {
    var self;

    self = this;
    return $('body').on('click touchend', touchables, function() {
      return self.onClick($(this));
    });
  },
  onClick: function(element) {
    var _this = this;

    element.addClass(classNames.touchActive);
    return element.data('touchActiveTimer', setTimeout(function() {
      element.removeClass(classNames.touchActive);
      if (element.data('touchActiveTimer') != null) {
        return clearTimeout(element.data('touchActiveTimer'));
      }
    }, activeStateDuration));
  }
};

},{"../core/device":2}],7:[function(require,module,exports){
var BaseView, HomeView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require('../core/BaseView');

HomeView = (function(_super) {
  __extends(HomeView, _super);

  HomeView.prototype.templateName = 'home';

  function HomeView() {
    this.bind = __bind(this.bind, this);
    this.getElements = __bind(this.getElements, this);
  }

  HomeView.prototype.getElements = function() {
    return HomeView.__super__.getElements.call(this);
  };

  HomeView.prototype.bind = function() {
    return HomeView.__super__.bind.call(this);
  };

  return HomeView;

})(BaseView);

module.exports = HomeView;

},{"../core/BaseView":11}],8:[function(require,module,exports){
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

},{"../core/BaseView":11,"../helpers/dom":9,"../core/device":2,"../helpers/physics":12,"../engine/World":13,"../engine/GameControls":14}],9:[function(require,module,exports){
module.exports = {
  getByRole: function(role, parent, filter) {
    var selector;

    if (parent == null) {
      parent = null;
    }
    if (filter == null) {
      filter = '';
    }
    selector = "[data-role='" + role + "']" + filter;
    if (parent == null) {
      return $(selector);
    } else {
      return parent.find(selector);
    }
  }
};

},{}],10:[function(require,module,exports){
var debug, defaultDuration, device, flipViews, horizontalSlide, placeAbsolutely, popView, wrap;

device = require('./device');

debug = require('./debug');

defaultDuration = debug.skipAnimations ? 0 : 400;

wrap = $('#view-wrap');

placeAbsolutely = function(view) {
  var deviceSize;

  deviceSize = device.getSize();
  return view.elements.main.css({
    position: 'absolute',
    top: 0,
    left: 0,
    width: deviceSize.width,
    height: deviceSize.height
  });
};

popView = function(scaleFrom, newView, oldView, callback, duration) {
  if (duration == null) {
    duration = defaultDuration;
  }
  placeAbsolutely(newView);
  newView.elements.main.css({
    scale: scaleFrom,
    opacity: 0
  });
  newView.elements.main.transition({
    scale: 1,
    opacity: 1
  });
  return setTimeout(function() {
    return callback(newView);
  }, defaultDuration);
};

horizontalSlide = function(dir, newView, oldView, callback, duration) {
  var deviceSize;

  if (duration == null) {
    duration = defaultDuration;
  }
  deviceSize = device.getSize();
  wrap.css({
    width: deviceSize.width,
    'overflow-x': 'hidden',
    position: 'relative'
  });
  placeAbsolutely(newView);
  newView.elements.main.css({
    x: (100 * dir) + '%'
  });
  newView.elements.main.transition({
    x: '0'
  }, duration);
  if (oldView != null) {
    oldView.elements.main.css({
      width: deviceSize.width,
      height: deviceSize.height
    });
    return oldView.elements.main.transition({
      x: (100 * -dir) + '%'
    }, duration, function() {
      return callback(newView);
    });
  }
};

flipViews = function(newView, oldView, callback) {
  var duration;

  duration = defaultDuration;
  placeAbsolutely(newView);
  oldView.elements.main.css({
    position: 'relative',
    'z-index': 1
  });
  newView.elements.main.css({
    'z-index': -1,
    rotateY: '-90deg',
    z: -500
  });
  oldView.elements.main.transition({
    rotateY: '90deg'
  }, duration / 2);
  return setTimeout(function() {
    return newView.elements.main.transition({
      rotateY: '0deg'
    }, duration / 2);
  }, duration / 2, function() {
    return callback(newView);
  });
};

module.exports = {
  'slide-right': function(newView, oldView, callback) {
    return horizontalSlide(1, newView, oldView, callback);
  },
  'slide-left': function(newView, oldView, callback) {
    return horizontalSlide(-1, newView, oldView, callback);
  },
  'flip': flipViews,
  'pop-out': function(newView, oldView, callback) {
    return popView(2.2, newView, oldView, callback);
  },
  'pop-in': function(newView, oldView, callback) {
    return popView(.7, newView, oldView, callback);
  }
};

},{"./device":2,"./debug":15}],11:[function(require,module,exports){
var BaseView, device, renderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

renderer = require('./renderer');

device = require('./device');

BaseView = (function() {
  function BaseView() {
    this.show = __bind(this.show, this);
    this.hide = __bind(this.hide, this);
    this.close = __bind(this.close, this);
    this.resize = __bind(this.resize, this);
    this.bind = __bind(this.bind, this);
    this.getElements = __bind(this.getElements, this);
    this.render = __bind(this.render, this);
  }

  BaseView.prototype.templateName = '';

  BaseView.prototype.fixHeight = false;

  BaseView.prototype.classNames = '';

  BaseView.prototype.context = {};

  BaseView.prototype.render = function(wrapper) {
    var rendered,
      _this = this;

    rendered = renderer.render("views/" + this.templateName, this.context);
    this.elements = {
      main: $("<div data-role='view' class='view " + this.classNames + "'>" + rendered + "</div>")
    };
    if (this.fixHeight) {
      this.elements.main.css({
        height: device.getSize().height
      });
    }
    this.getElements();
    if (wrapper != null) {
      this.elements.main.appendTo(wrapper);
    }
    this.resize();
    this.bind();
    $(window).on('resize', function() {
      return _this.resize();
    });
    return this;
  };

  BaseView.prototype.getElements = function() {};

  BaseView.prototype.bind = function() {};

  BaseView.prototype.resize = function() {};

  BaseView.prototype.close = function() {
    return this.elements.main.remove();
  };

  BaseView.prototype.hide = function() {
    return this.elements.main.hide();
  };

  BaseView.prototype.show = function() {
    this.elements.main.removeAttr('style');
    this.resize();
    return this.elements.main.show();
  };

  return BaseView;

})();

module.exports = BaseView;

},{"./renderer":3,"./device":2}],12:[function(require,module,exports){
var bodyDefaults, gameData;

gameData = require('../engine/gameData');

bodyDefaults = {
  interaction: 'dynamic',
  mat: 'default'
};

module.exports = {
  ratio: 30,
  Vector: Box2D.Common.Math.b2Vec2,
  World: Box2D.Dynamics.b2World,
  Body: Box2D.Dynamics.b2Body,
  BodyDef: Box2D.Dynamics.b2BodyDef,
  FixtureDef: Box2D.Dynamics.b2FixtureDef,
  dynamicBody: Box2D.Dynamics.b2Body.b2_dynamicBody,
  staticBody: Box2D.Dynamics.b2Body.b2_staticBody,
  kinematicBody: Box2D.Dynamics.b2Body.b2_kinematicBody,
  shapes: {
    Circle: Box2D.Collision.Shapes.b2CircleShape,
    Poly: Box2D.Collision.Shapes.b2PolygonShape
  },
  getBody: function(options) {
    switch (options.type) {
      case 'circle':
        return this.circleBody(options.x, options.y, options.radius, options);
      case 'rect':
        return this.rectBody(options.x, options.y, options.width, options.height, options);
      case 'poly':
        return this.polyBody(options.x, options.y, options.points, options);
      default:
        return null;
    }
  },
  getBodyPosition: function(body) {
    return {
      x: body.m_aabb.GetCenter().x * this.ratio,
      y: body.m_aabb.GetCenter().y * this.ratio
    };
  },
  moveBodyTo: function(body, x, y) {
    var newPos;

    newPos = new this.Vector(x / this.ratio, y / this.ratio);
    return body.m_body.SetPosition(newPos);
  },
  rectBody: function(x, y, width, height, options) {
    var bodyDef, fixtureDef;

    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Poly, options.mat);
    fixtureDef.shape.SetAsBox((width / 2) / this.ratio, (height / 2) / this.ratio);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  polyBody: function(x, y, points, options) {
    var bodyDef, fixtureDef, point, vertexes, _i, _len;

    vertexes = [];
    for (_i = 0, _len = points.length; _i < _len; _i++) {
      point = points[_i];
      vertexes.push(new this.Vector(point[0] / this.ratio, point[1] / this.ratio));
    }
    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Poly, options.mat);
    fixtureDef.shape.SetAsArray(vertexes, vertexes.length);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  circleBody: function(x, y, rad, options) {
    var bodyDef, fixtureDef;

    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Circle(rad / this.ratio), options.mat);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  getBodyDef: function(x, y, type, mat) {
    var bodyDef, material;

    if (type == null) {
      type = 'dynamic';
    }
    if (mat == null) {
      mat = 'default';
    }
    material = gameData.get('materials', mat);
    bodyDef = new this.BodyDef;
    if (type === 'static') {
      bodyDef.type = this.staticBody;
    } else if (type === 'kinematic') {
      bodyDef.type = this.kinematicBody;
    } else {
      bodyDef.type = this.dynamicBody;
    }
    bodyDef.linearDamping = material.linearDamping;
    bodyDef.position.x = x / this.ratio;
    bodyDef.position.y = y / this.ratio;
    return bodyDef;
  },
  getVector: function(x, y) {
    return new this.Vector(x, y);
  },
  getFixtureDef: function(shape, mat) {
    var fixtureDef, material;

    if (mat == null) {
      mat = 'default';
    }
    material = gameData.get('materials', mat);
    fixtureDef = new this.FixtureDef;
    return _.extend(fixtureDef, material, {
      shape: shape
    });
  }
};

},{"../engine/gameData":5}],13:[function(require,module,exports){
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

},{"./gameData":5,"./Layer":16,"../core/device":2,"../core/renderer":3,"../core/debug":15,"../helpers/debug":17,"../helpers/physics":12,"./Loop":18,"./Viewport":19,"./Walls":20}],14:[function(require,module,exports){
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

},{"./MouseControls":21,"../core/renderer":3,"../helpers/physics":12}],17:[function(require,module,exports){
var createDebugCtx, initPhysicsDebugger;

createDebugCtx = function(wrap, width, height) {
  var canvas;

  canvas = $("<canvas width='" + width + "' height='" + height + "'></canvas>");
  canvas.css({
    position: 'absolute',
    left: 0,
    top: 0
  });
  wrap.prepend(canvas);
  return canvas[0].getContext('2d');
};

initPhysicsDebugger = function(world) {
  var canvas, ctx, debugDraw, height, width;

  width = world.viewport.worldToScreen(world.viewport.width);
  height = world.viewport.worldToScreen(world.viewport.height);
  ctx = createDebugCtx(world.viewport.el, width, height);
  canvas = $(ctx.canvas);
  debugDraw = new Box2D.Dynamics.b2DebugDraw;
  debugDraw.SetSprite(ctx);
  debugDraw.SetDrawScale(30);
  debugDraw.SetFillAlpha(0.3);
  debugDraw.SetLineThickness(1.0);
  debugDraw.SetFlags(Box2D.Dynamics.b2DebugDraw.e_shapeBit || Box2D.Dynamics.b2DebugDraw.e_jointBit);
  world.b2dWorld.SetDebugDraw(debugDraw);
  world.loop.use(function() {
    return world.b2dWorld.DrawDebugData();
  });
  return debugDraw;
};

module.exports = {
  initPhysicsDebugger: initPhysicsDebugger
};

},{}],18:[function(require,module,exports){
var Loop, requestAnimationFrame,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
  return window.setTimeout(callback, 1000 / 60);
};

Loop = (function() {
  function Loop() {
    this.getFPS = __bind(this.getFPS, this);
    this.next = __bind(this.next, this);
    this.use = __bind(this.use, this);
    this.pause = __bind(this.pause, this);
    this.play = __bind(this.play, this);    this.callbacks = [];
    this.playing = false;
    this.fps = 0;
  }

  Loop.prototype.play = function() {
    this.playing = true;
    return requestAnimationFrame(this.next);
  };

  Loop.prototype.pause = function() {
    return this.playing = false;
  };

  Loop.prototype.use = function(callback) {
    return this.callbacks.push(callback);
  };

  Loop.prototype.next = function() {
    var callback, _i, _len, _ref;

    this.getFPS();
    _ref = this.callbacks;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      callback();
    }
    if (this.playing) {
      return requestAnimationFrame(this.next);
    }
  };

  Loop.prototype.getFPS = function() {
    var delta;

    if (!this.lastUpdate) {
      this.lastUpdate = new Date().getTime();
    }
    delta = (new Date().getTime() - this.lastCalledTime) / 1000;
    this.lastCalledTime = new Date().getTime();
    return this.fps = 1 / delta;
  };

  return Loop;

})();

module.exports = Loop;

},{}],15:[function(require,module,exports){
var helpers;

helpers = require('../helpers/debug');

module.exports = {
  skipAnimations: false,
  debugPhysics: false
};

},{"../helpers/debug":17}],16:[function(require,module,exports){
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

},{"./Entity":22,"../core/renderer":3,"../core/device":2}],19:[function(require,module,exports){
var Viewport, device, win;

device = require('../core/device');

win = $(window);

Viewport = (function() {
  function Viewport(el, width, height) {
    this.el = el;
    this.width = width;
    this.height = height;
    this.scaleRatio = 0;
    this.x = 0;
    this.y = 0;
    this.fitInScreen();
    this.elWidth = this.el.width();
    this.elHeight = this.el.height();
    this.center();
  }

  Viewport.prototype.center = function() {
    var screen;

    screen = device.getSize();
    return this.moveTo((screen.width - this.elWidth) / 2, (screen.height - this.elHeight) / 2);
  };

  Viewport.prototype.fitInScreen = function() {
    var screen;

    screen = device.getSize();
    this.scaleRatio = this.width / screen.width;
    return this.el.css({
      width: this.width / this.scaleRatio,
      height: this.height / this.scaleRatio
    });
  };

  Viewport.prototype.moveTo = function(x, y, duration, callback, ease) {
    var newX, newY;

    if (duration == null) {
      duration = 0;
    }
    if (callback == null) {
      callback = null;
    }
    if (ease == null) {
      ease = false;
    }
    if (ease && !duration) {
      newX = this.x + (x - this.x) / 20;
      newY = this.y + (y - this.y) / 20;
      if ((Math.abs(this.x - newX)) < .1 && (Math.abs(this.y - newY)) < .1) {
        return;
      } else {
        this.x = newX;
        this.y = newY;
      }
    } else {
      if (this.x === x && this.y === y) {
        return;
      }
      this.x = x;
      this.y = y;
    }
    if (!duration) {
      return this.el.css({
        x: this.x,
        y: this.y
      });
    } else {
      return this.el.transition({
        x: this.x,
        y: this.y
      }, duration, callback);
    }
  };

  Viewport.prototype.worldToScreen = function(value) {
    if (typeof value === 'object' && (value.x != null) && (value.y != null)) {
      return {
        x: this.worldToScreen(value.x),
        y: this.worldToScreen(value.y)
      };
    } else {
      return value / this.scaleRatio;
    }
  };

  Viewport.prototype.screenToWorld = function(value) {
    if (typeof value === 'object' && (value.x != null) && (value.y != null)) {
      return {
        x: this.screenToWorld(value.x),
        y: this.screenToWorld(value.y)
      };
    } else {
      return value * this.scaleRatio;
    }
  };

  Viewport.prototype.fits = function() {
    var screen;

    screen = device.getSize();
    return this.elHeight <= screen.height;
  };

  Viewport.prototype.followEntity = function(target, duration, callback) {
    var margin, maskedSize, screen, targetPos, x, y;

    if (duration == null) {
      duration = 0;
    }
    if (callback == null) {
      callback = null;
    }
    targetPos = this.worldToScreen(target.position());
    maskedSize = {
      width: this.elWidth,
      height: this.elHeight
    };
    x = -targetPos.x + this.elWidth / 2;
    y = -targetPos.y + this.elHeight / 2;
    screen = device.getSize();
    if (maskedSize.height >= screen.height) {
      margin = maskedSize.height - screen.height;
      if (y > 0) {
        y = 0;
      } else if (y < -margin) {
        y = -margin;
      }
    }
    if (maskedSize.width >= screen.width) {
      margin = maskedSize.width - screen.width;
      if (x > 0) {
        x = 0;
      } else if (x < -margin) {
        x = -margin;
      }
    }
    return this.moveTo(x, y, duration, callback, true);
  };

  return Viewport;

})();

module.exports = Viewport;

},{"../core/device":2}],20:[function(require,module,exports){
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

},{"./Wall":23,"./Body":24,"../core/renderer":3}],21:[function(require,module,exports){
var MouseControls, body, device;

device = require('../core/device');

body = $('body');

MouseControls = (function() {
  function MouseControls(wrap) {
    this.wrap = wrap;
    this.active = false;
    this.mouse = {
      x: null,
      y: null,
      down: false,
      dragging: false
    };
    this.clickStart = null;
    this.lastDrag = null;
    this.dragOffset = null;
    this.preventClick = false;
  }

  MouseControls.prototype.on = function() {
    this.active = true;
    return this.bind();
  };

  MouseControls.prototype.off = function() {
    this.active = false;
    return this.reset();
  };

  MouseControls.prototype.reset = function() {
    this.wrap.off(device.getEvent('mousemove'));
    this.wrap.off(device.getEvent('mousedown'));
    this.wrap.off(device.getEvent('mouseup'));
    return this.wrap.off(device.getEvent('tap'));
  };

  MouseControls.prototype.bind = function() {
    var self,
      _this = this;

    self = this;
    this.wrap.on(device.getEvent('mousemove'), function(e) {
      if (_this.active) {
        return _this.mouseMove(e);
      }
    });
    this.wrap.on(device.getEvent('mousedown'), function(e) {
      if (_this.active) {
        return _this.mouseDown(e);
      }
    });
    this.wrap.on(device.getEvent('mouseup'), function(e) {
      if (_this.active) {
        return _this.mouseUp(e);
      }
    });
    return this.wrap.on(device.getEvent('tap'), function(e) {
      if (_this.active && !_this.preventClick) {
        return _this.click($(e.target), e);
      }
    });
  };

  MouseControls.prototype.updateMousePosition = function(e) {
    var moved;

    moved = this.getMouseEvent(e);
    this.mouse.x = moved.pageX;
    return this.mouse.y = moved.pageY;
  };

  MouseControls.prototype.mouseDown = function(e) {
    this.preventClick = false;
    this.updateMousePosition(e);
    this.clickStart = {
      x: this.mouse.x,
      y: this.mouse.y
    };
    return this.mouse.down = true;
  };

  MouseControls.prototype.mouseMove = function(e) {
    var moved;

    if (this.mouse.dragging) {
      this.dragOffset = this.getDragOffset();
      this.lastDrag = {
        x: this.mouse.x,
        y: this.mouse.y
      };
      this.dragMove(this.dragOffset.last, this.dragOffset.total, e);
    } else if ((this.clickStart != null) && this.mouse.down) {
      moved = (Math.abs(this.clickStart.x - this.mouse.x)) + (Math.abs(this.clickStart.y - this.mouse.y));
      if (moved > 1) {
        this.lastDrag = this.clickStart;
        this.mouse.dragging = true;
        this.dragStart(e);
      }
    }
    return this.updateMousePosition(e);
  };

  MouseControls.prototype.mouseUp = function(e) {
    var dragOffset;

    if (this.mouse.dragging) {
      dragOffset = this.getDragOffset();
      this.mouse.dragging = false;
      this.dragStop(dragOffset.last, dragOffset.total, e);
    }
    return this.mouse.down = false;
  };

  MouseControls.prototype.click = function(target, e) {};

  MouseControls.prototype.getDragOffset = function() {
    var last, total;

    if (!this.mouse.dragging) {
      return null;
    }
    last = {
      x: this.mouse.x - this.lastDrag.x,
      y: this.mouse.y - this.lastDrag.y
    };
    total = {
      x: this.lastDrag.x - this.clickStart.x,
      y: this.lastDrag.y - this.clickStart.y
    };
    return {
      last: last,
      total: total
    };
  };

  MouseControls.prototype.dragStart = function(e) {
    return this.preventClick = true;
  };

  MouseControls.prototype.dragMove = function(lastOffset, totalOffset, e) {};

  MouseControls.prototype.dragStop = function(e) {};

  MouseControls.prototype.getRelativeMouse = function() {
    var pos, wrapOffset;

    wrapOffset = this.wrap.offset();
    pos = {
      x: this.mouse.x - wrapOffset.left,
      y: this.mouse.y - wrapOffset.top
    };
    return pos;
  };

  MouseControls.prototype.getMouseEvent = function(e) {
    if ((_.has(e, 'pageX')) && (_.has(e, 'pageY'))) {
      return e;
    } else if (_.has(e.originalEvent, 'touches')) {
      return e.originalEvent.touches[0];
    } else {
      return {
        pageX: 0,
        pageY: 0,
        target: null
      };
    }
  };

  return MouseControls;

})();

module.exports = MouseControls;

},{"../core/device":2}],22:[function(require,module,exports){
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

},{"./BaseItem":25,"./gameData":5,"./Sprite":26,"./Body":24}],23:[function(require,module,exports){
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

},{"./Body":24,"../core/renderer":3}],24:[function(require,module,exports){
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

},{"./BaseItem":25,"../helpers/physics":12}],25:[function(require,module,exports){
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

},{}],26:[function(require,module,exports){
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

},{"./BaseItem":25,"./SpriteRenderer":27,"./gameData":5}],27:[function(require,module,exports){
var SpriteRenderer, renderer;

renderer = require('../core/renderer');

SpriteRenderer = (function() {
  function SpriteRenderer(preset, viewport) {
    this.preset = preset;
    this.viewport = viewport;
    this.assets = this.variation != null ? this.preset.variations[this.variation] : this.preset.assets;
    this.poses = this.preset.poses;
    this.make();
  }

  SpriteRenderer.prototype.render = function() {
    var asset;

    this.el = $(renderer.render('game-sprite'));
    asset = this.assets[this.poses[this.pose].assets || 'default'];
    return this.el.css({
      width: Math.floor(this.viewport.worldToScreen(this.poses[this.pose].module[0])),
      height: Math.floor(this.viewport.worldToScreen(this.poses[this.pose].module[1])),
      backgroundImage: "url(assets/" + asset + ")",
      backgroundSize: "" + (Math.floor(this.width)) + "px " + (Math.floor(this.height)) + "px"
    });
  };

  SpriteRenderer.prototype.make = function() {
    this.width = this.viewport.worldToScreen(this.preset.size[0] || 0);
    this.height = this.viewport.worldToScreen(this.preset.size[1] || 0);
    if (this.preset.offset != null) {
      this.offset = {
        x: this.preset.offset[0],
        y: this.preset.offset[1]
      };
    } else {
      this.offset = {
        x: 0,
        y: 0
      };
    }
    this.offset = this.viewport.worldToScreen(this.offset);
    this.pose = 'default';
    this.frame = 0;
    return this.extendPoses();
  };

  SpriteRenderer.prototype.extendPoses = function() {
    var pose, poseId, _ref, _results;

    _ref = this.poses;
    _results = [];
    for (poseId in _ref) {
      pose = _ref[poseId];
      _results.push((function() {
        var _results1;

        _results1 = [];
        while (pose["extends"] != null) {
          _results1.push(this.extendPose(poseId, pose));
        }
        return _results1;
      }).call(this));
    }
    return _results;
  };

  SpriteRenderer.prototype.extendPose = function(poseId, pose) {
    var basePoseId;

    if (pose["extends"] != null) {
      basePoseId = pose["extends"];
      delete pose["extends"];
      return this.poses[poseId] = $.extend({}, this.poses[basePoseId], pose);
    }
  };

  return SpriteRenderer;

})();

module.exports = SpriteRenderer;

},{"../core/renderer":3}]},{},[1])
;