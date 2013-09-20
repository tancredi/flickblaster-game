
defaultMultiplier = 4

BaseActionableBehaviour = require './BaseActionableBehaviour'

###
## Turbo Behaviours class

Boosts player speed when hit

Read ActionableBehaviour for more
###

class TurboBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    @multiplier = @entity.attributes.multiplier or defaultMultiplier

    @sprite = @entity.sprites[0]      # Main Sprite
    @light = @sprite.decorators.light # Light decorator - shown when hovered

    # Hide the light for the time being
    (@light.css opacity: 0).show()

  activate: (player) ->
    return if @active

    super

    player.body.b2dBody.m_body.m_linearVelocity.x *= @multiplier
    player.body.b2dBody.m_body.m_linearVelocity.y *= @multiplier
    console.log player.body.b2dBody

    # Show the lights and fade them back out
    @light.stop().transition opacity: 1, 50, =>
      @light.stop().transition opacity: 0, 800

module.exports = TurboBehaviour