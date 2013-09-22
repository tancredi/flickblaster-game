
BaseBehaviour = require './BaseBehaviour'
gameData = require '../utils/gameData'

defaultStrength = 2000

###
## Cannon Behaviour class

Cannons apply a force to their target when actioned
###

class CannonBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @direction = @entity.attributes.direction
    @spriteEl = @entity.sprites[0].el

  shoot: ->
    pos = @entity.position()

    # Create bullet entity
    bullet =
      type: 'entity'
      preset: 'bullet'
      x: pos.x
      y: pos.y

    # Add bullet to the cannon layer
    bullet = @entity.layer.add bullet

    # Add the bullet as activator to all targets on stage
    targets = @world.getItemsByAttr 'type', 'target'
    (_ @world).emit 'addActivator', [ bullet ]

    # Animate cannon shot
    @spriteEl.css zoom: 1.2
    @spriteEl.stop().transition zoom: 1, 200

    # Apply force to bullet
    setTimeout ( =>
      bullet.body.applyForce @direction[0], @direction[1], defaultStrength
      ), 1

module.exports = CannonBehaviour
