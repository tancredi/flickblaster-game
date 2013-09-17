
###
Base Actionable Behaviour class

Base behaviour for buttons, sensors, teleports and all behaviours that react to player collisions

Calls .activate when touching the player, it needs to be deactivated before running again
###

BaseBehaviour = require './BaseBehaviour'
actions = require './actions'

class BaseActionableBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @active = false                                   # Won't .activate again when true
    players = @world.getItemsByAttr 'type', 'player'  # All players in the scene

    # Bind collision with the player
    for player in players
      @entity.onCollisionStart player, => @activate player

  # Extend this method to define a custom activation logic
  activate: ->
    return if @active

    if @entity.hasAttr 'action'
      actions.perform @entity.attributes.action, @

module.exports = BaseActionableBehaviour
