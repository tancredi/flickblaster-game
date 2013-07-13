
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
    @update()
    @el.appendTo @layer.element

    if @entity? then @el.data 'entity', @entity
    @el.data 'sprite', @

  moveTo: ->
    super
    @update()

  getAbsolutePosition: ->
    x = @x
    y = @y
    if @entity? then out = x: @entity.x - @entity.offset.x + x, y: @entity.y - @entity.offset.y + y
    else out = x: x, y: y
    return @viewport.worldToScreen out

  update: (x, y) ->
    pos = @getAbsolutePosition()
    @el.css
      x: pos.x - @renderer.width / 2
      y: pos.y - @renderer.height / 2

  export: -> x: @x, y: @y, type: @type

module.exports = Sprite
