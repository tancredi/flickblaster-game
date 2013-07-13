module.exports = {
  assets: {
    'default': 'sprites/ball.png'
  },
  size: [20, 20],
  offset: [0, 0],
  body: {
    type: 'circle',
    radius: 10
  },
  poses: {
    'default': {
      offset: [0, 0],
      module: [20, 20],
      frameLength: 0,
      repeat: true,
      play: false
    },
    'attack': {
      "extends": 'default',
      frames: [[1, 0], [0, 0]],
      frameLength: 100,
      repeat: true,
      play: true
    }
  },
  decorators: {}
};
