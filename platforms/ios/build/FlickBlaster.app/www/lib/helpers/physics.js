var bodyDefaults, gameData;

gameData = require('../engine/gameData');

bodyDefaults = {
  interaction: 'dynamic',
  mat: 'default'
};

module.exports = {
  ratio: 30,
  Vector: Box2D.Common.Math.b2Vec2,
  World: Box2D.Dynamics.b2World,
  Body: Box2D.Dynamics.b2Body,
  BodyDef: Box2D.Dynamics.b2BodyDef,
  FixtureDef: Box2D.Dynamics.b2FixtureDef,
  dynamicBody: Box2D.Dynamics.b2Body.b2_dynamicBody,
  staticBody: Box2D.Dynamics.b2Body.b2_staticBody,
  kinematicBody: Box2D.Dynamics.b2Body.b2_kinematicBody,
  shapes: {
    Circle: Box2D.Collision.Shapes.b2CircleShape,
    Poly: Box2D.Collision.Shapes.b2PolygonShape
  },
  getBody: function(options) {
    switch (options.type) {
      case 'circle':
        return this.circleBody(options.x, options.y, options.radius, options);
      case 'rect':
        return this.rectBody(options.x, options.y, options.width, options.height, options);
      case 'poly':
        return this.polyBody(options.x, options.y, options.points, options);
      default:
        return null;
    }
  },
  getBodyPosition: function(body) {
    return {
      x: body.m_aabb.GetCenter().x * this.ratio,
      y: body.m_aabb.GetCenter().y * this.ratio
    };
  },
  moveBodyTo: function(body, x, y) {
    var newPos;

    newPos = new this.Vector(x / this.ratio, y / this.ratio);
    return body.m_body.SetPosition(newPos);
  },
  rectBody: function(x, y, width, height, options) {
    var bodyDef, fixtureDef;

    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Poly, options.mat);
    fixtureDef.shape.SetAsBox((width / 2) / this.ratio, (height / 2) / this.ratio);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  polyBody: function(x, y, points, options) {
    var bodyDef, fixtureDef, point, vertexes, _i, _len;

    vertexes = [];
    for (_i = 0, _len = points.length; _i < _len; _i++) {
      point = points[_i];
      vertexes.push(new this.Vector(point[0] / this.ratio, point[1] / this.ratio));
    }
    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Poly, options.mat);
    fixtureDef.shape.SetAsArray(vertexes, vertexes.length);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  circleBody: function(x, y, rad, options) {
    var bodyDef, fixtureDef;

    options = $.extend(true, {}, bodyDefaults, options);
    fixtureDef = this.getFixtureDef(new this.shapes.Circle(rad / this.ratio), options.mat);
    bodyDef = this.getBodyDef(x, y, options.interaction, options.mat);
    return {
      bodyDef: bodyDef,
      fixtureDef: fixtureDef
    };
  },
  getBodyDef: function(x, y, type, mat) {
    var bodyDef, material;

    if (type == null) {
      type = 'dynamic';
    }
    if (mat == null) {
      mat = 'default';
    }
    material = gameData.get('materials', mat);
    bodyDef = new this.BodyDef;
    if (type === 'static') {
      bodyDef.type = this.staticBody;
    } else if (type === 'kinematic') {
      bodyDef.type = this.kinematicBody;
    } else {
      bodyDef.type = this.dynamicBody;
    }
    bodyDef.linearDamping = material.linearDamping;
    bodyDef.position.x = x / this.ratio;
    bodyDef.position.y = y / this.ratio;
    return bodyDef;
  },
  getVector: function(x, y) {
    return new this.Vector(x, y);
  },
  getFixtureDef: function(shape, mat) {
    var fixtureDef, material;

    if (mat == null) {
      mat = 'default';
    }
    material = gameData.get('materials', mat);
    fixtureDef = new this.FixtureDef;
    return _.extend(fixtureDef, material, {
      shape: shape
    });
  }
};
