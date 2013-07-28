
BaseBehaviour = require './BaseBehaviour'

class LaserBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    # body = @entity.body

    # options =
    #   x: body.x
    #   y: body.y
    #   width: body.width
    #   height: body.height
    #   color: colors[@entity.attributes.color]

    # @world.lasers.add options

module.exports = LaserBehaviour