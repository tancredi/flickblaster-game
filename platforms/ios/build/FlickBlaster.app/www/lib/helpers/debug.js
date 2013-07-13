var createDebugCtx, initPhysicsDebugger;

createDebugCtx = function(wrap, width, height) {
  var canvas;

  canvas = $("<canvas width='" + width + "' height='" + height + "'></canvas>");
  canvas.css({
    position: 'absolute',
    left: 0,
    top: 0
  });
  wrap.prepend(canvas);
  return canvas[0].getContext('2d');
};

initPhysicsDebugger = function(world) {
  var canvas, ctx, debugDraw, height, width;

  width = world.viewport.worldToScreen(world.viewport.width);
  height = world.viewport.worldToScreen(world.viewport.height);
  ctx = createDebugCtx(world.viewport.el, width, height);
  canvas = $(ctx.canvas);
  debugDraw = new Box2D.Dynamics.b2DebugDraw;
  debugDraw.SetSprite(ctx);
  debugDraw.SetDrawScale(30);
  debugDraw.SetFillAlpha(0.3);
  debugDraw.SetLineThickness(1.0);
  debugDraw.SetFlags(Box2D.Dynamics.b2DebugDraw.e_shapeBit || Box2D.Dynamics.b2DebugDraw.e_jointBit);
  world.b2dWorld.SetDebugDraw(debugDraw);
  world.loop.use(function() {
    return world.b2dWorld.DrawDebugData();
  });
  return debugDraw;
};

module.exports = {
  initPhysicsDebugger: initPhysicsDebugger
};
