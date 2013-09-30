
sounds = require '../utils/sounds'

###
## Bullet Behaviour class

Binds sounds to bullet collisions
###

BaseBehaviour = require './BaseBehaviour'

class BulletBehaviour extends BaseBehaviour

  constructor: ->
    super

    @bindSounds()

  bindSounds: ->
    @entity.body.onCollision 'start', null, =>
      sounds.play 'collisions', 'bullet'

module.exports = BulletBehaviour
