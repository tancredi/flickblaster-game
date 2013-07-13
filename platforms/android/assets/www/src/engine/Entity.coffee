
BaseItem = require './BaseItem'
gameData = require './gameData'
Sprite = require './Sprite'
Body = require './Body'

class Entity extends BaseItem
  itemType: 'entity'

  constructor: (options, @layer) ->
    super

    if options.preset
      preset = gameData.get 'presets', options.preset
      $.extend options, preset

    @attributes = options.attributes or null
    @id = options.id or null

    @offset = x: 0, y: 0

    @body = null
    @makeBody options.bodies

    @sprites = []
    @makeSprites options.sprites

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

  updatePos: (x, y) =>
    @x = x
    @y = y
    for sprite in @sprites
      sprite.update()

  update: =>
    sprite.update() for sprite in @sprites
    @body.update()
    if @body?
      bodyPos = @body.position()
      if @x isnt bodyPos.x or @y isnt bodyPos.y then @updatePos bodyPos.x, bodyPos.y

  position: ->
    if @body? @body.position()
    else x: @x, y: @y

  onCollision: (target, callback) -> @body.on 'collision', target.body, callback

  onCollisionStart: (target, callback) -> @body.on 'collisionstart', target.body, callback

  onCollision: (target, callback) -> @body.on 'collisionstop', target.body, callback

module.exports = Entity
