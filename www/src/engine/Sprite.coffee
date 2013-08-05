
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
    @flipped = x: false, y: false

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

  getScreenPosition: -> return @viewport.worldToScreen x: @x, y: @y

  updatePos: (x, y) ->
    pos = @getScreenPosition()
    w = @viewport.worldToScreen @renderer.getPose().module[0]
    h = @viewport.worldToScreen @renderer.getPose().module[1]
    @el.css
      x: pos.x - w / 2
      y: pos.y - h / 2

  export: -> x: @x, y: @y, type: @type

module.exports = Sprite
