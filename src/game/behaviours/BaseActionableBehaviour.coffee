
BaseBehaviour = require './BaseBehaviour'
actions = require './actions'

###
## Base Actionable Behaviour class

Base behaviour for buttons, sensors, teleports and all behaviours that react to activator collisions

Calls .activate when touching the activator, it needs to be deactivated before running again
###

class BaseActionableBehaviour extends BaseBehaviour

  constructor: (@entity, @world) ->
    super

    @active = false                                       # Won't .activate again when true
    activators = @world.getItemsByAttr 'activator', true  # All activators in the scene

    # Bind collision with the activators
    @addActivator activator for activator in activators

    (_ @world).on 'addActivator', (activator) =>
      @addActivator activator
  
  # Attach collosion listener to a new activator
  addActivator: (activator) ->
    @entity.onCollisionStart activator, => (@activate activator unless @active)

  # Extend this method to define a custom activation logic
  activate: (activator) ->
    return if @active

    if @entity.hasAttr 'action'
      actions.perform @entity.attributes.action, @

module.exports = BaseActionableBehaviour
