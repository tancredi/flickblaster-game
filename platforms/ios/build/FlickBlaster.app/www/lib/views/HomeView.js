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
