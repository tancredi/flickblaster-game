
###
Laser Behaviour class

Determines the behaviour of laser Entities

Laser Entities are Entities created through the editor with attributes 'type' and 'behaviour' set
to 'laser'
Entities of 'type' attribute set to 'lasers' will be passe by the World instance to its Lasers
manager and rendered with SVG
###

BaseBehaviour = require './BaseBehaviour'

class LaserBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @active = true                        # Laser state (Lethal when true)
    @player = @world.getItemById 'player' # Player Entity fetched from the World instance
    @touching = false                     # Laser is touching the player

    # Set the Entity's body to be a sensor - read Body for more
    @entity.body.setSensor true

    # Bind callback to collisions with player instance
    @entity.onCollisionStart @player, =>
      @touching = true
      @burnPlayer() if @active

    # Bind callback to collision stop with player instance
    @entity.onCollisionStop @player, =>
      @touching = false

    # Switch off if the laser Entity has the attribute 'off' set to true
    @off() if (@entity.hasAttr 'off') and @entity.attributes.off

  burnPlayer: ->
    # Fade in burning FX decorator
    sprite = @player.sprites[0]
    decorator = sprite.getDecorator 'burn'
    decorator.fadeIn 100

    # Fade the player Sprite out
    sprite.el.fadeOut 300, =>
      @player.remove()
      (_ @player).emit 'die'

  # Turn the laser off
  off: ->
    for element in @entity.elements
      element.remove()
      @cachedElements = @entity.elements
    @world.lasers.refresh()

    @active = false

  # Turn the laser on
  on: ->
    for element in @cachedElements
      @world.lasers.el.append element
    @world.lasers.refresh()

    # Burn the player if already touching
    if @touching then @burnPlayer()

    @active = true

  # Toggle laser state
  toggle: -> if @active then @off() else @on()

module.exports = LaserBehaviour
