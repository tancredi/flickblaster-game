
gameData = require './gameData'
Layer = require './Layer'
device = require '../core/device'
renderer = require '../core/renderer'
debug = require '../core/debug'
debugHelpers = require '../helpers/debug'
phys = require '../helpers/physics'
Loop = require './Loop'
Viewport = require './Viewport'
Walls = require './Walls'
Lasers = require './Lasers'
CollisionManager = require './CollisionManager'

# Default options
defaults =
  gravity: [ 0, 0 ]

# World - Ties together level data, physics, gameloop, stage element, game layers, game items

class World

  constructor: (@wrap, levelId, options = {}) ->
    @ready = false                                            # Level data
    @readyCallbacks = []                                      # .onReady callbacks
    options = $.extend true, {}, defaults, options            # Options extended on top of defaults
    @gravity = options.gravity                                # [ x, y ] gravity
    @items = []                                               # All game items (entities, bodies and sprites)
    @layers = {}                                              # Game layers
    @stage = ($ renderer.render 'game-stage').appendTo @wrap  # Stage
    @loop = new Loop                                          # Gameloop

    @initPhysics()
    @loadLevel levelId
    @onReady => @start()

  initPhysics: ->
    # Get FPS from last iteration
    fps = @loop.getFPS()

    # Create Box2D gravity vector, Box2D world and initialise CollisionManager
    @gravity = new phys.Vector @gravity[0], @gravity[1]
    @b2dWorld = new phys.World @gravity, true
    @collisionManager = new CollisionManager @

  playPhysics: ->
    # Start Box2D physics
    @b2dInterval = window.setInterval =>
      @b2dWorld.Step 1 / 60, 10, 10
      @b2dWorld.ClearForces()
    , 1000 / 60

  onReady: (callback) ->
    # Attach a callback to level data loading - execute straight away if loaded
    @readyCallbacks.push callback
    callback() if @ready

  loadLevel: (levelId, callback) ->
    # Load level data from gameData module and initialise
    gameData.loadLevel levelId, (level) =>
      @level = level
      @viewport = new Viewport @stage, @level.size[0], @level.size[1]

      # Create empty layers
      @addLayer 'lasers', 'entity'
      @addLayer 'entities', 'entity'

      # Add walls to the scene
      @walls = new Walls @

      # Load lasers data
      @lasers = new Lasers @, @getLayerById 'lasers'

      # Load and add entities
      for entity in (@loadLayerData 'entities').items
        @addItem 'entities', entity

      # Load and add walls
      for body in (@loadLayerData 'walls').items
        @walls.add body
      @walls.refresh()

      # Load and add lasers
      for laser in (@loadLayerData 'lasers').items
        entity = @addItem 'lasers', laser
        entity.elements = @lasers.add laser
      @lasers.refresh()

      # Trigger ready state
      @ready = true
      cb() for cb in @readyCallbacks

  addItem: (layerId, item) ->
    layer = @getLayerById layerId
    item = layer.add item
    @items.push item
    return item

  loadLayerData: (layerId) ->
    if layerId?
      for layer in @level.layers
        if layer.id is layerId then return layer
    return null

  addLayer: (id, type) -> @layers[id] = new Layer @, type, id

  getLayerById: (layerId) ->
    if @layers[layerId] then return @layers[layerId]
    return null

  addBody: (body) ->
    # Initialise Box2D body from object containing fixtureDev and bodyDef
    return @b2dWorld.CreateBody(body.bodyDef).CreateFixture body.fixtureDef

  getItemById: (id) ->
    for item in @items
      if item.id is id then return item
    return null

  getItemsByAttr: (attr, value) ->
    matches = []
    for item in @items
      if item.attributes?
        if (_.has item.attributes, attr) and item.attributes[attr] is value
          matches.push item
    return matches

  start: ->
    # Initialise gameloop and behaviours
    @initBehaviours()
    @loop.use => @update()
    if debug.debugPhysics then debugHelpers.initPhysicsDebugger @

  play: ->
    # Start gameloop and physics
    @playPhysics()
    @loop.play()

  stop: ->
    # Stop gameloop and physics
    @loop.pause()
    clearInterval @b2dInterval

  initBehaviours: ->
    # Initialise all entities behaviours
    for item in @items
      item.initBehaviour() if item.itemType is 'entity'

  update: ->
    #Update each layer
    layer.update() for layerId, layer of @layers

module.exports = World
