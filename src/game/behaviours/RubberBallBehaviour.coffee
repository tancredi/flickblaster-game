
sounds = require '../utils/sounds'

###
## Rubber Ball class

Binds sounds to rubber balls collisions
###

BaseBehaviour = require './BaseBehaviour'

class RubberBall extends BaseBehaviour

  constructor: ->
    super

    @bindSounds()

  bindSounds: ->
    @entity.body.onCollision 'start', null, =>
      sounds.play 'collisions', 'rubber'

module.exports = RubberBall
