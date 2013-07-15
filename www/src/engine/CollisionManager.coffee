
phys = require '../helpers/physics'

class CollisionManager

  constructor: (@world) ->
    @callbacks =
      start: []
      end: []
      pre: []
      post: []
    @listener = new phys.ContactListener
    @bind()

  bind: ->
    @listener.BeginContact = (contact) => cb contact for cb in @callbacks.start
    @listener.EndContact = (contact) => cb contact for cb in @callbacks.end
    @listener.PreSolve = (contact, impulse) => cb contact, impulse for cb in @callbacks.pre
    @listener.PostSolve = (contact, oldManifold) => cb contact, oldManifold for cb in @callbacks.post
    @world.b2dWorld.SetContactListener @listener

  on: (evt, callback) -> @callbacks[evt].push callback

module.exports = CollisionManager