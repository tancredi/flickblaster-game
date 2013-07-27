
BaseBehaviour = require './BaseBehaviour'

class PlayerBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    targets = @world.getItemsByAttr 'target'
    @hoveredTarget = null
    @potted = false

    for target in targets
      if target.data.targetType is @entity.data.targetType

        @entity.onCollisionStart target, =>
          @hoveredTarget = target
          (_ target).emit 'hover'

        @entity.onCollisionEnd target, =>
          @hoveredTarget = null
          (_ target).emit 'release'

  update: ->
    super
    if @hoveredTarget? and not @potted
      speedX = @entity.body.b2dBody.m_body.m_linearVelocity.x
      speedY = @entity.body.b2dBody.m_body.m_linearVelocity.y
      totalSpeed = (Math.abs speedX) + (Math.abs speedY)
      if totalSpeed < .3
        @potIn @hoveredTarget
        @potted = true

  potIn: (target) ->
    # dist = @entity.distance target, false
    # @entity.body.applyForce dist.x, dist.y, -40
    # @entity.body.setDrag 20
    @potFx =>
      @entity.remove()
      (_ @world).emit 'pot', [ @entity, target ]

  potFx: (callback) ->
    for sprite in @entity.sprites
      sprite.el.transition scale: .1, opacity: 0, 600
    setTimeout callback, 600 if callback?

module.exports = PlayerBehaviour