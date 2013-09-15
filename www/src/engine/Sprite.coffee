
###
Sprite class

Game Item displaying an asset or a portion of it in a DOM element on the stage
Can be a child of an Entity, in which case it will wrap it's element in the Entity's wrap element,
otherwise will render inside its layer

The rendering makes use of the SpriteRenderer class
It also makes use of decorators, which are other overlapped sprites that can be switched on an
off to create effects

Initialise with a 'type' option, which will be the key of its preset in www/game/sprites.json
Read Game Data class for more on JSON assets
###

BaseItem = require './BaseItem'
SpriteRenderer = require './SpriteRenderer'
gameData = require './gameData'
renderer = require '../core/renderer'

wallsColor = '#a2bfc9'

class Sprite extends BaseItem
  type: 'sprite'

  constructor: (options, @layer) ->
    super

    @type = options.type                              # The ID of the sprite preset
    @preset = gameData.get 'sprites', @type           # Preset based on
    @entity = options.entity or null                  # Parent Entity
    @viewport = @layer.viewport                       # Shortcut to Layer's Viewport
    @renderer = new SpriteRenderer @preset, @viewport # Renderer responsible for DOM manipulation
    @decorators = {}                                  # Object containing the decorator elements
    @flipped = x: false, y: false                     # Configuration for X and Y mirroring

    @render()
    @renderDecorators()

  # Create one element for each decorator in the preset
  renderDecorators: ->
    for key, decorator of @preset.decorators
      el = $ renderer.render 'game-decorator'
      el.css backgroundImage: "url(assets/#{decorator})"
      el.hide()
      @el.append el
      @decorators[key] = el

  # Show the decorator with given ID
  showDecorator: (decoratorId) -> (@getDecorator decoratorId).show()

  # Hide the decorator with given ID
  hideDecorator: (decoratorId) -> (@getDecorator decoratorId).hide()

  # Find the decorator with given ID
  getDecorator: (decoratorId) -> @decorators[decoratorId]

  render: =>
    @renderer.render()
    @el = @renderer.el
    @updatePos()

    # Append element to parent entity or parent layer
    if @entity?
      @el.appendTo @entity.el
      if @entity.hasAttr 'wall-bg'
        @el.css backgroundColor: wallsColor
    else
      @el.appendTo @layer.element

    # Attach Sprite instance to DOM element
    # This will make it easy to trace it back from bound DOM events
    if @entity? then @el.data 'entity', @entity
    @el.data 'sprite', @

  moveTo: ->
    super

    @updatePos()

  # Mirror on given axis (0: x, 1: y)
  flip: (dir) ->
    if dir is 0
      @flipped.x = not @flipped.x
    else if dir is 1
      @flipped.y = not @flipped.y

    scaleX = if @flipped.x then -1 else 1
    scaleY = if @flipped.y then -1 else 1

    @el.css scale: "#{scaleX}, #{scaleY}"

  remove: ->
    super

    @el.remove()

  # Returns current position in screen coordinates
  getScreenPosition: -> return @viewport.worldToScreen x: @x, y: @y

  # Updates DOM element position to match
  updatePos: (x, y) ->
    pos = @getScreenPosition()
    w = @viewport.worldToScreen @renderer.getPose().module[0]
    h = @viewport.worldToScreen @renderer.getPose().module[1]
    @el.css
      x: pos.x - w / 2
      y: pos.y - h / 2

module.exports = Sprite
