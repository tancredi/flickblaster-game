
BaseItem = require './BaseItem'
SpriteRenderer = require './SpriteRenderer'
gameData = require './gameData'
renderer = require '../core/renderer'

class Sprite extends BaseItem
  type: 'sprite'

  constructor: (options, @layer) ->
    super
    @type = options.type
    @entity = options.entity or null
    @preset = gameData.get 'sprites', @type
    @viewport = @layer.viewport
    @renderer = new SpriteRenderer @preset, @viewport
    @decorators = {}
    @render()
    @renderDecorators()

  renderDecorators: ->
    for key, decorator of @preset.decorators
      el = $ renderer.render 'game-decorator'
      el.css backgroundImage: "url(assets/#{decorator})"
      el.hide()
      @el.append el
      @decorators[key] = el

  showDecorator: (decoratorId) -> (@getDecorator decoratorId).show()

  hideDecorator: (decoratorId) -> (@getDecorator decoratorId).hide()

  getDecorator: (decoratorId) -> @decorators[decoratorId]

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

  remove: ->
    super

    @el.remove()

  getScreenPosition: -> return @viewport.worldToScreen x: @x, y: @y

  updatePos: (x, y) ->
    pos = @getScreenPosition()
    @el.css
      x: pos.x - @renderer.width / 2
      y: pos.y - @renderer.height / 2

  export: -> x: @x, y: @y, type: @type

module.exports = Sprite
