
BaseBehaviour = require './BaseBehaviour'

###
## Target Behaviour class

Targets are holes the player has to aim to to win the game

On the same level there can theoretically be multiple targets and players
Once a target gets hit by a player with the same `data.targetType` property, it will communicate
the point to the world and stay in active state
###

class TargetBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    # True when scored by player
    @potted = false

    @bind()

    # Get lights decorator element
    @lights = @entity.sprites[0].getDecorator 'lights'
    @lights.show().css opacity: 0

  bind: ->
    players = @world.getItemsByAttr 'type', 'player'

    # Bind collision listeners to all players on stage
    for player in players
        # Only consider players of the same type as the target
      if player.data.targetType is @entity.data.targetType

        @entity.onCollisionStart player, =>
          return if @potted or player.behaviour.dead

          @lightsOn()
          @pot()

        @entity.onCollisionEnd player, =>
          @lightsOff() unless @potted

  pot: ->
    @potted = true
    # Score pot
    (_ @world).emit 'pot', [ @ ]

  # Fade the lights in
  lightsOn: -> @lights.stop().transition opacity: 1, 500

  # Fade the lights out
  lightsOff: -> @lights.stop().transition opacity: 0, 500

  # Overwrite basic behaviour (No need to go anywhere o update the sprite)
  update: ->

module.exports = TargetBehaviour
