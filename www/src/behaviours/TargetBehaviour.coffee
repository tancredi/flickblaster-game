
class BaseBehaviour

  constructor: (@entity, @world) ->
    (_ @entity).on 'hover', => @lightsOn()
    (_ @entity).on 'release', => @lightsOff()
    @lights = @entity.sprites[0].getDecorator 'lights'
    @lights.show().css opacity: 0

  lightsOn: -> @lights.stop().transition opacity: 1, 500

  lightsOff: -> @lights.stop().transition opacity: 0, 500

  update: ->

module.exports = BaseBehaviour