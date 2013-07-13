
BaseView = require '../core/BaseView'
getByRole = require('../helpers/dom').getByRole
device = require '../core/device'
phys = require '../helpers/physics'
World = require '../engine/World'
GameControls = require '../engine/GameControls'

win = $ window

class GameView extends BaseView
  templateName: 'game'

  constructor: ->
    super

  getElements: ->
    super()

    screenSize = device.getSize()
    @elements.main.css
      overflow: 'hidden'
      width: screenSize.width
      height: screenSize.height
      position: 'relative'
      left: ( win.width() - screenSize.width ) / 2
      top: ( win.height() - screenSize.height ) / 2

  bind: ->
    super()

    @world = new World @elements.main, '01'

    @world.onReady => @startGame()

  startGame: ->
    @world.start()
    @world.loop.play()

    @target = @world.getItemById 'target'
    @player = @world.getItemById 'player'

    @player.onCollisionStart @target, =>
      console.log 'Win!'

    @showIntro =>
      @world.loop.use @update
      @controls = new GameControls @
      @controls.on()

  showIntro: (callback) ->
    @viewportFits = @world.viewport.fits()
    if not @viewportFits
      @world.viewport.followEntity @target, 1000, =>
        @world.viewport.followEntity @player, 1000, =>
          callback()
    else callback()

  update: =>
    if not @viewportFits
      @world.viewport.followEntity @player

module.exports = GameView
