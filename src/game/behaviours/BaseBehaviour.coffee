
###
## Base Behaviour class

This class is ment to be extended when creating a new Behaviour

Behaviours are instanciated as children of Entities and are passed their parent and their parent's
world, having so full access to manipulate the game logic

The parent Entity will call .update at every frame in the GameLoop
Read Entity for more
###

class BaseBehaviour

  constructor: (@entity, @world) ->

  # The base .update behaviour for all Entities
  update: ->
	# Update all Sprite children of the Entity
    sprite.update() for sprite in @entity.sprites

    # Update the entity's Body if any
    if @entity.body?
      @entity.body.update()
      bodyPos = @entity.body.position()
      if @entity.x isnt bodyPos.x or @entity.y isnt bodyPos.y then @entity.updatePos()

module.exports = BaseBehaviour
