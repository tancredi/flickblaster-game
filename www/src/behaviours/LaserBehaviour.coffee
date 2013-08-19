
BaseBehaviour = require './BaseBehaviour'

class LaserBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @active = true
    @entity.body.setSensor true
    @player = @world.getItemById 'player'
    @touching = false

    @entity.onCollisionStart @player, =>
      @touching = true
      @burnPlayer() if @active

    @entity.onCollisionStart @player, =>
      @touching = false

    @off() if (@entity.hasAttr 'off') and @entity.attributes.off

  burnPlayer: ->
    sprite = @player.sprites[0]
    decorator = sprite.getDecorator 'burn'
    decorator.fadeIn 100
    sprite.el.fadeOut 300, =>
      @player.remove()
      (_ @player).emit 'die'

  off: ->
    for element in @entity.elements
      element.remove()
      @cachedElements = @entity.elements
    @world.lasers.refresh()
    @active = false

  on: ->
    for element in @cachedElements
      @world.lasers.el.append element
    @world.lasers.refresh()
    if @touching then @burnPlayer()
    @active = true

  toggle: -> if @active then @off() else @on()

module.exports = LaserBehaviour