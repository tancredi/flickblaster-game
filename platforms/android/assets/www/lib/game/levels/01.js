module.exports = {
  size: [300, 400],
  walls: true,
  layers: {
    entities: [
      {
        sprite: 'ball',
        bahaviour: 'ball',
        id: 'ball',
        x: 150,
        y: 200
      }, {
        sprite: 'ball',
        bahaviour: 'ball',
        id: 'enemy',
        x: 190,
        y: 200
      }
    ],
    collisions: [
      {
        type: "poly",
        points: [
          {
            x: 0,
            y: 0
          }, {
            x: 300,
            y: 0
          }, {
            x: 150,
            y: -150
          }, {
            x: 2198,
            y: 276
          }
        ]
      }
    ]
  }
};
