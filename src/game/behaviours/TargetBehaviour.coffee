
BaseActionableBehaviour = require './BaseActionableBehaviour'

###
## Target Behaviour class

Targets are the platforms player has to action to win the game

On the same level there can theoretically be multiple targets and players
Once a target gets hit by a player of another object with attribute `trigger-target` set to `true`,
it will communicate the point to its World and stay in active state
###

class TargetBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    # Get lights decorator element
    @lights = @entity.sprites[0].getDecorator 'lights'
    @lights.show().css opacity: 0

  # Bind an activator the target
  activate: (activator) ->
    super

    return if activator.behaviour.dead

    @lightsOn()
    @pot()

    @entity.onCollisionEnd activator, =>
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
