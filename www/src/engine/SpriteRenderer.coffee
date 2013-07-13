
renderer = require '../core/renderer'

class SpriteRenderer

  constructor: (@preset, @viewport) ->
    @assets = if @variation? then @preset.variations[@variation] else @preset.assets
    @poses = @preset.poses

    @make()

  render: ->
    @el = $ renderer.render 'game-sprite'
    asset = @assets[@poses[@pose].assets or 'default']
    @el.css
      width: Math.floor @viewport.worldToScreen @poses[@pose].module[0]
      height: Math.floor @viewport.worldToScreen @poses[@pose].module[1]
      backgroundImage: "url(assets/#{asset})"
      backgroundSize: "#{Math.floor @width}px #{Math.floor @height}px"

  make: ->
    @width = @viewport.worldToScreen (@preset.size[0] or 0)
    @height = @viewport.worldToScreen (@preset.size[1] or 0)

    if @preset.offset? then @offset = x: @preset.offset[0], y: @preset.offset[1]
    else @offset = x: 0, y: 0

    @offset = @viewport.worldToScreen @offset

    @pose = 'default'
    @frame = 0
    @extendPoses()

  extendPoses: ->
    for poseId, pose of @poses
      while pose.extends?
        @extendPose poseId, pose

  extendPose: (poseId, pose) ->
    if pose.extends?
      basePoseId = pose.extends
      delete pose.extends
      @poses[poseId] = $.extend {}, @poses[basePoseId], pose

module.exports = SpriteRenderer
