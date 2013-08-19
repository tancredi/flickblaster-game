
BaseBehaviour = require './BaseBehaviour'
actions = require './actions'

class BaseActionableBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @active = false
    players = @world.getItemsByAttr 'type', 'player'

    for player in players
      @entity.onCollisionStart player, => @activate player

  activate: ->
    return if @active

    if @entity.hasAttr 'action'
      actions.perform @entity.attributes.action, @

module.exports = BaseActionableBehaviour