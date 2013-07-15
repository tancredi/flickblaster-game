
BaseBehaviour = require './BaseBehaviour'

class PlayerBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @targets = @world.getItemsByAttr 'target'
    for target in @targets
      @entity.onCollisionStart target, => @potIn target

  potIn: (target) ->
    dist = @entity.distance target, false
    @entity.body.applyForce dist.x, dist.y, -40
    @entity.body.setDrag 20
    @potFx => @entity.remove()

  potFx: (callback) ->
    for sprite in @entity.sprites
      sprite.el.transition scale: .1, opacity: 0, 600
    setTimeout callback, 600 if callback?

module.exports = PlayerBehaviour