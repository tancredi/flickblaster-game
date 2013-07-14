
BaseItem = require './BaseItem'
SpriteRenderer = require './SpriteRenderer'
gameData = require './gameData'

class Sprite extends BaseItem
  type: 'sprite'

  constructor: (options, @layer) ->
    super
    @type = options.type
    @entity = options.entity or null
    @preset = gameData.get 'sprites', @type
    @viewport = @layer.viewport
    @renderer = new SpriteRenderer @preset, @viewport
    @render()

  render: =>
    @renderer.render()
    @el = @renderer.el
    @updatePos()
    if @entity?
      @el.appendTo @entity.el
    else
      @el.appendTo @layer.element

    if @entity? then @el.data 'entity', @entity
    @el.data 'sprite', @

  moveTo: ->
    super
    @updatePos()

  getScreenPosition: -> return @viewport.worldToScreen x: @x, y: @y

  updatePos: (x, y) ->
    pos = @getScreenPosition()
    @el.css
      x: pos.x - @renderer.width / 2
      y: pos.y - @renderer.height / 2

  export: -> x: @x, y: @y, type: @type

module.exports = Sprite
