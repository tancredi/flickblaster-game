
###
Target Behaviour class

Targets are the sort of holes in which you have to pot the player to win the game

The pot logic is contained in PlayerBehaviour, this behaviour mainly shows effects on the target
when hovered by the player
###

class BaseBehaviour

  constructor: (@entity, @world) ->
    # Bind to event fired by player on the instance
    (_ @entity).on 'hover', => @lightsOn()
    (_ @entity).on 'release', => @lightsOff()

    # Get lights decorator element
    @lights = @entity.sprites[0].getDecorator 'lights'
    @lights.show().css opacity: 0

  # Fade the lights in
  lightsOn: -> @lights.stop().transition opacity: 1, 500

  # Fade the lights out
  lightsOff: -> @lights.stop().transition opacity: 0, 500

  # Overwrite basic behaviour (No need to go anywhere o update the sprite)
  update: ->

module.exports = BaseBehaviour