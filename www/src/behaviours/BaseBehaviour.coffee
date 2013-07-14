
class BaseBehaviour

  constructor: (@entity, @world) ->

  update: ->
    @entity.body.update()
    sprite.update() for sprite in @entity.sprites
    if @entity.body?
      bodyPos = @entity.body.position()
      if @entity.x isnt bodyPos.x or @entity.y isnt bodyPos.y then @entity.updatePos()

module.exports = BaseBehaviour