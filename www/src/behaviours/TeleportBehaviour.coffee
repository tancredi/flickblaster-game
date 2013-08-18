
BaseBehaviour = require './BaseBehaviour'

class TeleportBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @sprite = @entity.sprites[0]
    @lights = @sprite.decorators.lights

    @active = false

    players = @world.getItemsByAttr 'type', 'player'

    for player in players
      @entity.onCollisionStart player, => @teleport player

  teleport: (player) ->
    return if @active

    if @entity.hasAttr 'target-id'
      target = @world.getItemById @entity.attributes['target-id']

    playerSprite = player.sprites[0].el

    if target?
      @activate()

      if target.attributes.type? and target.attributes.type is 'teleport'
        target.behaviour.activate 200

      playerSprite.transition opacity: 0, 30, =>
        player.body.moveTo target.position()
        playerSprite.transition opacity: 1, 30

  activate: (delay = 0) ->
    @active = true

    setTimeout ( =>
      (@lights.css opacity: 0, rotation: 0).show().stop().transition opacity: 1, rotate: 90, 100, 'easeOutCirc', =>
        @active = false
        @lights.stop().transition opacity: 0, rotate: 180, 200, 'easeInCirc', =>
    ), delay

  update: ->

module.exports = TeleportBehaviour