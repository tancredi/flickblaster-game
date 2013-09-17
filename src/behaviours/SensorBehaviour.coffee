
###
Sensor Behaviours class

Sensors execute an action specified through their 'action' attribute every time they're hovered by
the player

Read ActionableBehaviour for more
###

BaseActionableBehaviour = require './BaseActionableBehaviour'

class SensorBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    @sprite = @entity.sprites[0]      # Main Sprite
    @light = @sprite.decorators.light # Light decorator - shown when hovered

    # Hide the light for the time being
    (@light.css opacity: 0).show()

  activate: ->
    return if @active

    super

    # Show the lights and fade them back out
    @light.stop().transition opacity: 1, 50, =>
      @light.stop().transition opacity: 0, 500

module.exports = SensorBehaviour