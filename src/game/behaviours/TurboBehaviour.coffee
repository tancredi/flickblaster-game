
defaultMultiplier = 4
directionalMultiplier = 10
directionalDelay = 20

BaseActionableBehaviour = require './BaseActionableBehaviour'
sounds = require '../utils/sounds'

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

    sounds.play 'turbo', 'activate'

    super

    playerVelocity = player.body.b2dBody.m_body.m_linearVelocity

    if @entity.hasAttr 'direction'
      dir = @entity.attributes.direction
      setTimeout ( =>
        playerVelocity.x += dir[0] * @multiplier * directionalMultiplier
        playerVelocity.y += dir[1] * @multiplier * directionalMultiplier
        ), directionalDelay
    else
      player.body.b2dBody.m_body.m_linearVelocity.x *= @multiplier
      player.body.b2dBody.m_body.m_linearVelocity.y *= @multiplier

    # Show the lights and fade them back out
    @light.stop().transition opacity: 1, 50, =>
      @light.stop().transition opacity: 0, 800

module.exports = TurboBehaviour