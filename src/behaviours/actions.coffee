
###
Actions module

Actions are abstracted, common functions used by some behaviours

They are mapped to keys that match the 'action' attribute specified on Entities - mainly using
the editor, which some behaviours will parse and exectute passing the target Entity
###

# Get target/targets of entity specified with 'target-id' or 'target-group' attributes
getEntityTargets = (entity, world, type = null) ->
  targets = []

  if entity.hasAttr 'target-id'
    targets.push world.getItemById entity.attributes['target-id']

  if entity.hasAttr 'target-group'
    if entity.attributes['target-group'] is 'all' and type?
      targets = targets.concat world.getItemsByAttr 'type', type
    else
      targets = targets.concat world.getItemsByAttr 'group', entity.attributes['target-group']

  return targets

actions =

  # Toggle a laser entity on / off
  'laser-toggle': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world, 'laser'
    target.behaviour.toggle() for target in targets

  # Switch a laser entity off
  'laser-off': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world, 'laser'
    target.behaviour.off() for target in targets

  # Switch a laser entity on
  'laser-on': (entity, world, behaviour) ->
    targets = getEntityTargets entity, world, 'laser'
    target.behaviour.on() for target in targets
    
module.exports =

  # Shortcut to directly execute an action given its 'attribute key' and a target Entity
  perform: (action, target) ->
    if actions[action]?
      actions[action] target.entity, target.world, target
