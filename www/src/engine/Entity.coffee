
BaseItem = require './BaseItem'
gameData = require './gameData'
behaviours = require '../behaviours/index'
Sprite = require './Sprite'
Body = require './Body'
renderer = require '../core/renderer'

class Entity extends BaseItem
  itemType: 'entity'

  constructor: (options, @layer) ->
    super

    if options.preset
      preset = gameData.get 'presets', options.preset
      $.extend true, options, preset

    @attributes = options.attributes or {}
    @id = options.id or null
    @data = options.data or {}
    @behaviourType = options.behaviour or 'base'

    @offset = x: 0, y: 0

    @render()

    @body = null
    @makeBody options.bodies

    @sprites = []
    @makeSprites options.sprites

    @updatePos()

  initBehaviour: -> @behaviour = new behaviours[@behaviourType] @, @layer.world

  render: ->
    @el = $ renderer.render 'game-entity'
    @el.appendTo @layer.element
    @el.data 'entity', @

  makeSprites: (sprites) ->
    for sprite in sprites
      options = $.extend true, {}, sprite, entity: @
      @sprites.push new Sprite options, @layer

    if (@hasAttr 'flip-x') and @attributes['flip-x']
      (sprite.flip 0) for sprite in @sprites

    if (@hasAttr 'flip-y') and @attributes['flip-y']
      (sprite.flip 1) for sprite in @sprites

  hasAttr: (attr) -> return _.has @attributes, attr

  makeBody: (bodies) ->
    for body, i in bodies
      options = $.extend true, {}, body
      options.x = @x + body.x
      options.y = @y + body.y
      if @hasAttr 'interaction'
        options.interaction = @attributes.interaction

      if i is 0
        @offset = x: body.x, y: body.y
        @body = new Body options, @layer.world
        if @hasAttr 'sensor'
          @body.setSensor true
      else
        @body.addShape options

  setPose: (pose) => @sprite.pose = pose

  updatePos: ->
    if @body?
      @el.css @layer.viewport.worldToScreen @body.position()

  distance: (target, absolute = true) ->
    diff = x: @x - target.x, y: @x - target.y
    return Math.abs diff if absolute
    return diff

  update: -> @behaviour.update()

  remove: ->
    super

    sprite.remove() for sprite in @sprites
    @body.remove() if @body?
    @removed = true

  position: ->
    if @body? then @body.position()
    else x: @x, y: @y

  onCollisionPre: (target, callback) -> @body.onCollision 'pre', target.body, callback

  onCollisionPost: (target, callback) -> @body.onCollision 'post', target.body, callback

  onCollisionStart: (target, callback) -> @body.onCollision 'start', target.body, callback

  onCollisionEnd: (target, callback) -> @body.onCollision 'end', target.body, callback

module.exports = Entity
