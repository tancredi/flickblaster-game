
###
Body class

This game item type interfaces the game logic with Box2D bodies
Bodies can be added to the scene either stand-alone of as children of entities

Currently supported types of Body are:
1. Circle:      ('circle') Initialise with x, y and radius
2. Rectangles:  ('rect') Initialise with x, y, width and height
3. Polygons:    ('poly') Initialise with x, y and an array with all coordinates of points
###

BaseItem = require './BaseItem'
phys = require '../helpers/physics'

class Body extends BaseItem
  itemType: 'body'

  constructor: (options, @world) ->
    super

    @type = options.type        # Body type
    @viewport = @world.viewport # Viewport (Needed to match scaling)

    # Adds right properties in base of body type
    switch @type
      when 'circle'
        @radius = options.radius
      when 'rect'
        @width = options.width
        @height = options.height
      when 'poly'
        @points = []
        for i in [ 0 ... options.points.length / 2 ]
          @points.push [ options.points[i * 2], options.points[i * 2 + 1] ]
      else
        # Won't continue if body type is not supported
        return

    # Creates the Box2D body through the physics module and adds it to the scene
    bodyData = phys.getBody @parseOptions options
    @b2dBody = @world.addBody bodyData

  # Parses and scales to viewport given body options
  parseOptions: (options) ->
    out =
      type: options.type                            # Body type
      mat: options.mat or 'default'                 # Material
      interaction: options.interaction or 'dynamic' # 'dynamic', 'static' or 'kinematic'

    if options.x? and options.y?
      # Translate position to screen coordinates
      out.x = @viewport.worldToScreen options.x
      out.y = @viewport.worldToScreen options.y

    if options.radius?
      # Translate radius to screen coordinates
      out.radius = @viewport.worldToScreen options.radius

    if options.width? and options.height?
      # Translate width and height to screen coordinates
      out.width = @viewport.worldToScreen options.width
      out.height = @viewport.worldToScreen options.height

    if options.points?
      # Translate points array data structure from
      # [ ax, ay, bx, by, .. ] to [ ax, ay, bx, by, .. ]
      out.points = []
      for point in @points
        x = @viewport.worldToScreen point[0]
        y = @viewport.worldToScreen point[1]
        out.points.push [ x, y ]

    return out

  moveTo: (pos) ->
    x = ( @viewport.worldToScreen pos.x ) / phys.ratio
    y = ( @viewport.worldToScreen pos.y ) / phys.ratio
    pos = new phys.Vector x, y
    # Horrible hack to force the Box2D body to change position
    setTimeout ( => @b2dBody.m_body.SetPosition pos ), .001

  # Add a shape to the same body
  addShape: (options) ->
    options = @parseOptions options
    body = phys.getBody options

    # Translates relative position to screen coordinates
    pos = @viewport.worldToScreen @position()

    # Places the new body relatively to the main one
    body.fixtureDef.shape.m_p.x = ( options.x - pos.x ) / phys.ratio
    body.fixtureDef.shape.m_p.y = ( options.y - pos.y ) / phys.ratio

    # Adds the body to itself
    @b2dBody.m_body.CreateFixture body.fixtureDef

  # Applies a force with given direction and multiplier
  applyForce: (x, y, multiplier = 0) ->
    point = @b2dBody.m_body.GetWorldCenter()
    x = (@viewport.worldToScreen x) * multiplier
    y = (@viewport.worldToScreen y) * multiplier
    vector = phys.getVector x, y
    @b2dBody.m_body.ApplyForce vector, point

  # Retuns position in world coordinates
  position: -> @viewport.screenToWorld phys.getBodyPosition @b2dBody

  # Set sensor state
  # If true the object will stop interactive in collisions, but keep triggering them
  setSensor: (state) ->
    # @b2dBody.m_body.m_fixtureList.m_isSensor = state
    # @b2dBody.m_body.m_isSensor = state
    # @b2dBody.SetSensor state
    @b2dBody.m_body.m_fixtureList.SetSensor state

  setDrag: (amt) -> # Default material's drag is 0.8
    @b2dBody.m_body.m_linearDamping = amt

  remove: ->
    # Remove the body from the entity, if child of an entity, then destroy its Box2D body
    if @entity? then @entity.body = null
    @world.b2dWorld.DestroyBody @b2dBody.m_body

  # Attach an event listener in the collision manager
  # For available events read CollisionManager
  onCollision: (evt, target, callback) ->
    @world.collisionManager.on evt, (c) =>
      bodyA = c.m_fixtureA.m_body
      bodyB = c.m_fixtureB.m_body

      if not target?
        if bodyA is @b2dBody.m_body then callback c
        return
      else
        targetBody = target.b2dBody.m_body
        if (bodyA is targetBody and bodyB is @b2dBody.m_body) or (bodyA is @b2dBody.m_body and bodyB is targetBody)
          callback c

module.exports = Body
