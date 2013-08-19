
getEntityTargets = (entity, world) ->
  targets = []

  if entity.hasAttr 'target-id'
    targets.push world.getItemById entity.attributes['target-id']

  if entity.hasAttr 'target-group'
    targets = targets.concat world.getItemsByAttr 'group', entity.attributes['target-group']

  return targets

actions =

  'laser-toggle': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world
    target.behaviour.toggle() for target in targets

  'laser-off': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world
    target.behaviour.off() for target in targets

  'laser-on': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world
    target.behaviour.on() for target in targets
    
module.exports =
  perform: (action, target) ->
    if actions[action]?
      actions[action] target.entity, target.world, target