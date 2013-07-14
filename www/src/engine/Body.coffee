
BaseItem = require './BaseItem'
phys = require '../helpers/physics'

class Body extends BaseItem
  itemType: 'body'

  constructor: (options, @world) ->
    super
    @type = options.type
    @viewport = @world.viewport
    @touchListeners = []

    if @type is 'circle'
      @radius = options.radius
    else if @type is 'rect'
      @width = options.width
      @height = options.height
    else if @type is 'poly'
      @points = []
      for i in [ 0 ... options.points.length / 2 ]
        @points.push [ options.points[i * 2], options.points[i * 2 + 1] ]
    else return

    @b2dBody = @world.addBody (phys.getBody @getBodyOptions options)

  getBodyOptions: (options) ->
    out = type: options.type, interaction: options.interaction ? true

    if options.x? and options.y?
      out.x = @viewport.worldToScreen options.x
      out.y = @viewport.worldToScreen options.y

    if options.radius?
      out.radius = @viewport.worldToScreen options.radius

    if options.width? and options.height?
      out.width = @viewport.worldToScreen options.width
      out.height = @viewport.worldToScreen options.height

    if options.points?
      out.points = []
      for point in @points
        x = @viewport.worldToScreen point[0]
        y = @viewport.worldToScreen point[1]
        out.points.push [ x, y ]

    return out

  addShape: (options) ->
    options = @getBodyOptions options
    body = phys.getBody options
    pos = @viewport.worldToScreen @position()
    body.fixtureDef.shape.m_p.x = ( options.x - pos.x ) / 30
    body.fixtureDef.shape.m_p.y = ( options.y - pos.y ) / 30
    @b2dBody.m_body.CreateFixture body.fixtureDef

  applyForce: (x, y, multiplier = 0) ->
    point = @b2dBody.m_body.GetWorldCenter()
    x = (@viewport.worldToScreen x) * multiplier
    y = (@viewport.worldToScreen y) * multiplier
    vector = phys.getVector x, y
    @b2dBody.m_body.ApplyForce vector, point

  position: -> @viewport.screenToWorld phys.getBodyPosition @b2dBody

  setSensor: (state) -> @b2dBody.SetSensor state

  setDrag: (amt) -> @b2dBody.m_body.m_linearDamping = amt

  update: ->
    for listener in @touchListeners
      contact = @b2dBody.m_body.GetContactList()
      if contact?
        if contact.other is listener.body
          if listener.colliding and listener.evt is 'collision'
            callback()
          else if not listener.colliding
            listener.colliding = true
            listener.callback() if listener.evt is 'collisionstart'
        else if listener.colliding
          listener.colliding = false
          listener.callback() if listener.evt is 'collisionstop'

  on: (evt, target, callback) ->
    @touchListeners.push
      target: target
      evt: evt
      body: target.b2dBody.m_body
      callback: callback
      colliding: false

module.exports = Body
