
BaseActionableBehaviour = require './BaseActionableBehaviour'

class TeleportBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    @sprite = @entity.sprites[0]
    @lights = @sprite.decorators.lights

  activate: (player) ->
    return if @active
    super

    if @entity.hasAttr 'target-id'
      target = @world.getItemById @entity.attributes['target-id']

    playerSprite = player.sprites[0].el

    if target?
      @lightsFx()

      if target.attributes.type? and target.attributes.type is 'teleport'
        target.behaviour.lightsFx 200

      playerSprite.transition opacity: 0, 30, =>
        player.body.moveTo target.position()
        playerSprite.transition opacity: 1, 30

  lightsFx: (delay = 0) ->
    @active = true

    # setTimeout ( =>
    #   @active = false
    # ), 110

    setTimeout ( =>
      (@lights.css opacity: 0, rotation: 0).show().stop().transition opacity: 1, rotate: 90, 100, 'easeOutCirc', =>
        @active = false
        @lights.stop().transition opacity: 0, rotate: 180, 200, 'easeInCirc'
    ), delay

  update: ->

module.exports = TeleportBehaviour