
renderer = require '../../core/renderer'

BaseItem = require './BaseItem'
Sprite = require './Sprite'
Body = require './Body'
gameData = require '../utils/gameData'
behaviours = require '../behaviours/index'

###
## Entity class

Entities are the central players on the scene - They can have a body and multiple sprites which
will move relatively to their position, they can be associated to a Behaviour, which will be
manage their instance at every .update, they can have attributes which play a central role in
the game mechanics.

Entities can be instanciated with a preset from the ones contained in `www/game/presets.json`
###

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

    # Create the element
    @render()

    # Create the Body
    @makeBody options.bodies

    # Create the Sprites
    @sprites = []
    @makeSprites options.sprites

    @updatePos()

  # Instanciate the Behaviour - It will handle the Entity at every .update
  initBehaviour: ->
    @behaviour = new behaviours[@behaviourType] @, @layer.world

  # Render the wrapping element
  render: ->
    @el = $ renderer.render 'game-entity'
    @el.appendTo @layer.element
    @el.data 'entity', @

  # Instanciate the sprites
  makeSprites: (sprites) ->
    for sprite in sprites
      options = $.extend true, {}, sprite, entity: @
      @sprites.push new Sprite options, @layer

    # If specified in the Entity attributes, mirror the sprite on the X and/or Y axis

    if (@hasAttr 'flip-x') and @attributes['flip-x']
      (sprite.flip 0) for sprite in @sprites

    if (@hasAttr 'flip-y') and @attributes['flip-y']
      (sprite.flip 1) for sprite in @sprites

    if (@hasAttr 'z-index')
      (@el.css zIndex: @attributes['z-index']) for sprite in @sprites

  # Returns true if given attribute is defined
  hasAttr: (attr) ->
    return _.has @attributes, attr

  # Parses some custom attributes and instanciates the body
  makeBody: (bodies) ->
    for body, i in bodies
      options = $.extend true, {}, body

      options.x = @x + body.x
      options.y = @y + body.y

      # If specified in the Entity attributes, set custom interaction or material in the Body

      if @hasAttr 'interaction'
        options.interaction = @attributes.interaction

      if @hasAttr 'material'
        options.mat = @attributes.material

      # Create the first body in the bodies array and adds other bodies shapes to it
      if i is 0
        @bodyOffset = x: body.x, y: body.y
        @offset = x: body.x, y: body.y
        @body = new Body options, @layer.world
        # If specified in the Entity attributes, make the body a sensor
        if @hasAttr 'sensor'
          @body.setSensor true
      else
        @body.addShape options

  setPose: (pose) => @sprite.pose = pose

  updatePos: ->
    if @body?
      pos = @layer.viewport.worldToScreen  @body.position()
      pos.x -= @layer.viewport.worldToScreen @bodyOffset.x
      pos.y -= @layer.viewport.worldToScreen @bodyOffset.y
      @el.css pos

  distance: (target, absolute = true) ->
    diff = x: @x - target.x, y: @x - target.y
    return Math.abs diff if absolute
    return diff

  # Update all children position
  update: ->
    @behaviour.update()

  # Remove Entity element, sprites and bodies from the scene
  remove: ->
    super

    @el.remove();
    sprite.remove() for sprite in @sprites
    @body.remove() if @body?

    @removed = true

  # Returns the Entity's position in game coordinates
  position: ->
    if @body?
      pos = @body.position()
      return x: pos.x - @bodyOffset.x, y: pos.y - @bodyOffset.y
    else
      return x: @x, y: @y

  # Methods to bind callbacks to collision events on the Entity's body
  # Read CollisionManager for more about these events
  onCollisionPre: (target, callback) -> @body.onCollision 'pre', target.body, callback
  onCollisionPost: (target, callback) -> @body.onCollision 'post', target.body, callback
  onCollisionStart: (target, callback) -> @body.onCollision 'start', target.body, callback
  onCollisionEnd: (target, callback) -> @body.onCollision 'end', target.body, callback

module.exports = Entity
