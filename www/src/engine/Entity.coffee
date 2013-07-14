
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
      $.extend options, preset

    @attributes = options.attributes or null
    @id = options.id or null
    @data = options.data or {}

    @offset = x: 0, y: 0

    @render()

    @body = null
    @makeBody options.bodies

    @sprites = []
    @makeSprites options.sprites

    @updatePos()

    if options.behaviour then @behaviour = new behaviours[options.behaviour] @
    else @behaviour = new behaviours.base @

  render: ->
    @el = $ renderer.render 'game-entity'
    @el.appendTo @layer.element
    @el.data 'entity', @

  makeSprites: (sprites) ->
    for sprite in sprites
      options = $.extend true, {}, sprite, entity: @
      @sprites.push new Sprite options, @layer

  hasAttr: (attrName) ->
    return false if not @attributes?
    return (@attributes.indexOf attrName) isnt -1

  makeBody: (bodies) ->
    for body, i in bodies
      options = $.extend true, {}, body
      options.x = @x + body.x
      options.y = @y + body.y
      if i is 0
        @offset = x: body.x, y: body.y
        @body = new Body options, @layer.world
        if @hasAttr 'sensor'
          @body.setSensor true
      else
        @body.addShape options

  setPose: (pose) => @sprite.pose = pose

  updatePos: ->
    pos = @body.position()
    @x = pos.x
    @y = pos.y
    @el.css @layer.viewport.worldToScreen x: @x, y: @y

  distance: (target, absolute = true) ->
    diff = x: @x - target.x, y: @x - target.y
    return Math.abs diff if absolute
    return diff

  update: -> @behaviour.update()

  position: ->
    if @body? @body.position()
    else x: @x, y: @y

  onCollision: (target, callback) -> @body.on 'collision', target.body, callback

  onCollisionStart: (target, callback) -> @body.on 'collisionstart', target.body, callback

  onCollision: (target, callback) -> @body.on 'collisionstop', target.body, callback

module.exports = Entity
