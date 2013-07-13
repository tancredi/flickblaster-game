var bind, device, gameData, init, onDeviceReady, renderer, touchables, views;

device = require('./core/device');

renderer = require('./core/renderer');

views = require('./core/views');

gameData = require('./engine/gameData');

touchables = require('./ui/touchables');

views.load({
  home: require('./views/HomeView'),
  game: require('./views/GameView')
});

renderer.templates = window.templates;

init = function() {
  if (device.isTouch()) {
    return bind();
  } else {
    return onDeviceReady();
  }
};

bind = function() {
  return document.addEventListener('deviceready', onDeviceReady, false);
};

onDeviceReady = function() {};

touchables.initialise();

gameData.init();

gameData.onReady(function() {
  return views.open('game');
});

init();
