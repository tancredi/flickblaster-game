
soundsMap =
  button: [ 'press' ]
  cannon: [ 'shoot' ]
  collisions: [ 'bullet', 'player', 'rubber' ]
  target: [ 'achieved', 'electric', 'gas' ]
  laser: [ 'burn', 'toggle' ]
  player: [ 'click', 'release' ]
  teleport: [ 'activate' ]
  turbo: [ 'activate' ]

sounds = {}
soundsDir = 'sounds'
formats = [ 'mp3', 'wav' ]

module.exports =

  active: true

  init: ->
    for category, soundNames of soundsMap
      sounds[category] = {}

      for name in soundNames
        filename = "#{soundsDir}/#{category}/#{name}"
        sound = new buzz.sound filename, formats: formats
        sounds[category][name] = sound

  play: (category, name) -> sounds[category][name].play() if @active

  on: -> @active = true

  off: -> @active = false
