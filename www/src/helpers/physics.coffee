
gameData = require '../engine/gameData'

bodyDefaults =
  interaction: 'dynamic'
  mat: 'default'

module.exports =
  ratio: 30
  Vector: Box2D.Common.Math.b2Vec2
  World: Box2D.Dynamics.b2World
  Body: Box2D.Dynamics.b2Body
  BodyDef: Box2D.Dynamics.b2BodyDef
  FixtureDef: Box2D.Dynamics.b2FixtureDef
  dynamicBody: Box2D.Dynamics.b2Body.b2_dynamicBody
  staticBody: Box2D.Dynamics.b2Body.b2_staticBody
  kinematicBody: Box2D.Dynamics.b2Body.b2_kinematicBody
  ContactListener: Box2D.Dynamics.b2ContactListener
  shapes:
    Circle: Box2D.Collision.Shapes.b2CircleShape
    Poly: Box2D.Collision.Shapes.b2PolygonShape

  getBody: (options) ->
    switch options.type
      when 'circle' then return @circleBody options.x, options.y, options.radius, options
      when 'rect' then return @rectBody options.x, options.y, options.width, options.height, options
      when 'poly' then return @polyBody options.x, options.y, options.points, options
      else return null

  getBodyPosition: (body) ->
    pos = body.m_aabb.GetCenter()
    return x: pos.x * @ratio, y: pos.y * @ratio

  moveBodyTo: (body, x, y) ->
    newPos = new @Vector (x / @ratio), (y / @ratio)
    body.m_body.SetPosition newPos

  rectBody: (x, y, width, height, options) ->
    options = $.extend true, {}, bodyDefaults, options
    fixtureDef = @getFixtureDef (new @shapes.Poly), options.mat
    fixtureDef.shape.SetAsBox ( width / 2 ) / @ratio, ( height / 2 ) / @ratio
    bodyDef = @getBodyDef x, y, options.interaction, options.mat
    return { bodyDef, fixtureDef }

  polyBody: (x, y, points, options) ->
    vertexes = []
    for point in points
      vertexes.push new @Vector point[0] / @ratio, point[1] / @ratio
    options = $.extend true, {}, bodyDefaults, options
    fixtureDef = @getFixtureDef (new @shapes.Poly), options.mat
    fixtureDef.shape.SetAsArray vertexes, vertexes.length
    bodyDef = @getBodyDef x, y, options.interaction, options.mat
    return { bodyDef, fixtureDef }

  circleBody: (x, y, rad, options) ->
    options = $.extend true, {}, bodyDefaults, options
    fixtureDef = @getFixtureDef (new @shapes.Circle rad / @ratio), options.mat
    bodyDef = @getBodyDef x, y, options.interaction, options.mat
    return { bodyDef, fixtureDef }

  getBodyDef: (x, y, type = 'dynamic', mat = 'default') ->
    material = gameData.get 'materials', mat
    bodyDef = new @BodyDef
    if type is 'static' then bodyDef.type = @staticBody
    else if type is 'kinematic' then bodyDef.type = @kinematicBody
    else bodyDef.type = @dynamicBody
    bodyDef.linearDamping = material.linearDamping if material.linearDamping
    bodyDef.position.x = x / @ratio
    bodyDef.position.y = y / @ratio
    return bodyDef

  getVector: (x, y) -> new @Vector ( x ), ( y )

  getFixtureDef: (shape, mat = 'default') ->
    material = gameData.get 'materials', mat
    fixtureDef = new @FixtureDef
    return _.extend fixtureDef, material, shape: shape
