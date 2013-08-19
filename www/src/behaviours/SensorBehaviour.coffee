
BaseActionableBehaviour = require './BaseActionableBehaviour'

class SensorBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    @sprite = @entity.sprites[0]
    @light = @sprite.decorators.light

    (@light.css opacity: 0).show()

  activate: ->
    return if @active
    super

    @light.stop().transition opacity: 1, 50, =>
      @light.stop().transition opacity: 0, 500

module.exports = SensorBehaviour