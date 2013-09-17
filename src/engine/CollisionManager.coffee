
###
Collision Manager class

Work around for major issues encountered with several different ways of
binding events to Box2D collisions.

The events you can bind are:
1. 'start':         
2. 'end':           Triggered after the collision is solved
3. 'BeginContact':  Triggered before the contact has happened
4. 'EndContact':    Triggered after the contact has happened
###

phys = require '../helpers/physics'

class CollisionManager

  # Initialise on top of a World instance to read collisione from
  constructor: (@world) ->
    # The events that can be bound
    @callbacks = start: [], end: [], pre: [], post: []
    @listener = new phys.ContactListener # Box2D ContactListener

    @bind()

  # Creates Box2D hook to all callbacks for specified event
  bind: ->
    @listener.BeginContact = (contact) => cb contact for cb in @callbacks.start
    @listener.EndContact = (contact) => cb contact for cb in @callbacks.end
    @listener.PreSolve = (contact, impulse) => cb contact, impulse for cb in @callbacks.pre
    @listener.PostSolve = (contact, oldManifold) => cb contact, oldManifold for cb in @callbacks.post
    @world.b2dWorld.SetContactListener @listener

  # Call to bind an event to all collisions of that type
  on: (evt, callback) ->
    @callbacks[evt].push callback

module.exports = CollisionManager