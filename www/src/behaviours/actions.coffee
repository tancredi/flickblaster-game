
actions =

  'laser-toggle': (entity, world, behaviour) ->
    targets = []

    if entity.hasAttr 'target-id'
      console.log 'ffds'
      targets.push world.getItemById entity.attributes['target-id']

    if entity.hasAttr 'target-group'
      targets = targets.concat world.getItemsByAttr 'group', entity.attributes['target-group']

    for target in targets
      target.behaviour.toggle()
    
module.exports =
  perform: (action, target) ->
    if actions[action]?
      actions[action] target.entity, target.world, target