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
