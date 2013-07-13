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
