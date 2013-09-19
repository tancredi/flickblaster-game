
BaseBehaviour = require './BaseBehaviour'

###
## Player Behaviour class

Defines the behaviour of the player on stage
Shamefully, the player is that little red disc you flick around the stage when playing
###

class PlayerBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    targets = @world.getItemsByAttr 'type', 'target'  # All targets on stage
    @hoveredTarget = null                             # The target currently on, if any
    @potted = false                                   # True when has collided with a target

    # Bind collision listeners to all targets
    for target in targets
        # Only consider targets of the same type as the player
      if target.data.targetType is @entity.data.targetType

        @entity.onCollisionStart target, =>
          @hoveredTarget = target
          # Use Underscore observer patter to tell the target it's being hovered
          (_ target).emit 'hover'

        @entity.onCollisionEnd target, =>
          @hoveredTarget = null
          # Use Underscore observer patter to tell the target it's been released
          (_ target).emit 'release'

  update: ->
    super

    if @hoveredTarget? and not @potted
      @potIn @hoveredTarget

  # Drive the player towards a glorious victory
  potIn: (target) ->
    @potted = true
    @potFx =>
      @entity.remove()
      (_ @world).emit 'pot', [ @entity, target ]

  # Fade the player Sprites out
  potFx: (callback) ->
    for sprite in @entity.sprites
      sprite.el.transition scale: .1, opacity: 0, 600
    setTimeout callback, 600 if callback?

module.exports = PlayerBehaviour
