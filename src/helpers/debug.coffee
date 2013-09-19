
###
## Debug helpers

Debugging tools
###

# Create a full-width canvas element, add it to the DOM and return its 2D context
createDebugCtx = (wrap, width, height) ->
    canvas = $ "<canvas width='#{width}' height='#{height}'></canvas>"
    canvas.css position: 'absolute', left: 0, top: 0
    wrap.prepend canvas
    return canvas[0].getContext '2d'

# Creates and displays the Box2D canvas debugger for a given World
initPhysicsDebugger = (world) ->
  width = world.viewport.worldToScreen world.viewport.width
  height = world.viewport.worldToScreen world.viewport.height
  ctx = createDebugCtx world.viewport.el, width, height
  canvas = $ ctx.canvas
  debugDraw = new Box2D.Dynamics.b2DebugDraw
  debugDraw.SetSprite ctx
  debugDraw.SetDrawScale 30
  debugDraw.SetFillAlpha 0.3
  debugDraw.SetLineThickness 1.0
  debugDraw.SetFlags Box2D.Dynamics.b2DebugDraw.e_shapeBit or Box2D.Dynamics.b2DebugDraw.e_jointBit
  world.b2dWorld.SetDebugDraw debugDraw

  world.loop.use ->
    world.b2dWorld.DrawDebugData()

  return debugDraw

module.exports = { initPhysicsDebugger }
