
renderer = require '../../core/renderer'

assets = require './assets'

###
## Sprite Renderer

Takes care of the DOM rendering and manipulation, updating and animating of Sprites Initialise
with a preset

Presets are defined in www/game/sprites.json and loaded throught the GameData module
###

class SpriteRenderer

  constructor: (@preset, @viewport) ->
    @assets = @preset.assets
    @poses = @preset.poses

    @make()

  # Render and setup the DOM element
  render: ->

    @el = $ renderer.render 'game-sprite'

    # Get the current pose asset
    asset = @assets[@poses[@pose].assets or 'default']

    # Get full asset path
    assetPath = assets.getAssetPath asset

    @el.css
      width: Math.floor @viewport.worldToScreen @poses[@pose].module[0]
      height: Math.floor @viewport.worldToScreen @poses[@pose].module[1]
      backgroundImage: "url(#{assetPath})"
      backgroundSize: "#{Math.floor @width}px #{Math.floor @height}px"
      backgroundPosition: "-#{@offset.x}px -#{@offset.y}px"

  make: ->
    # Size of the whole spritesheet
    @width = @viewport.worldToScreen (@preset.size[0] or 0)
    @height = @viewport.worldToScreen (@preset.size[1] or 0)

    # Sets offset if specified by the preset
    if @preset.offset? then @offset = x: @preset.offset[0], y: @preset.offset[1]
    else @offset = x: 0, y: 0

    # Translate offset in screen coordinates
    @offset = @viewport.worldToScreen @offset

    # Sets initial values
    @pose = 'default'
    @frame = 0
    @extendPoses()

  # Return current pose
  getPose: -> @poses[@pose]

  # Sort poses inheritance
  extendPoses: ->
    for poseId, pose of @poses
      while pose.extends?
        @extendPose poseId, pose

  # Sort inheritance of given pose
  extendPose: (poseId, pose) ->
    if pose.extends?
      basePoseId = pose.extends
      delete pose.extends
      @poses[poseId] = $.extend {}, @poses[basePoseId], pose

module.exports = SpriteRenderer
