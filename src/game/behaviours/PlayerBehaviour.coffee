
BaseBehaviour = require './BaseBehaviour'

###
## Player Behaviour class

Defines the behaviour of the player on stage
Shamefully, the player is just that little red disc you flick around the stage when playing
###

class PlayerBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    @dead = false

  win: (callback) ->
    for sprite in @entity.sprites
      sprite.el.transition scale: .1, opacity: 0, 600
    setTimeout callback, 600 if callback?

  die: -> @dead = true

module.exports = PlayerBehaviour
