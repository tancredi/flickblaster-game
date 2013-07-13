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
