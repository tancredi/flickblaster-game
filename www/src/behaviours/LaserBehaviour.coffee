
BaseBehaviour = require './BaseBehaviour'

class LaserBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @entity.body.setSensor true

    @player = @world.getItemById 'player'

    @entity.onCollisionStart @player, => @burnPlayer()

  burnPlayer: ->
    sprite = @player.sprites[0]
    decorator = sprite.getDecorator 'burn'
    decorator.fadeIn 100
    sprite.el.fadeOut 300, =>
      @player.remove()
      (_ @player).emit 'die'

    # body = @entity.body

    # options =
    #   x: body.x
    #   y: body.y
    #   width: body.width
    #   height: body.height
    #   color: colors[@entity.attributes.color]

    # @world.lasers.add options

module.exports = LaserBehaviour