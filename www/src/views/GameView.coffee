
BaseView = require '../core/BaseView'
getByRole = (require '../helpers/dom').getByRole
device = require '../core/device'
debug = require '../core/debug'
phys = require '../helpers/physics'
World = require '../engine/World'
GameControls = require '../engine/GameControls'
views = require '../core/views'

win = $ window

introDuration = if debug.skipAnimations then 0 else 2400

class GameView extends BaseView
  templateName: 'game'
  classNames: 'view-game'
  fixHeight: true

  constructor: (@levelName) ->
    super

  getElements: ->
    super

    @elements.restart = getByRole 'restart', @elements.main
    @elements.back = getByRole 'back', @elements.main

  bind: ->
    super

    @world = new World @elements.main, @levelName

    @elements.restart.on (device.getEvent 'click'), (e) =>
      views.open 'game', null, null, false, @levelName
      e.preventDefault()

    @elements.back.on (device.getEvent 'click'), (e) =>
      views.open 'levels', 'pop-out'
      e.preventDefault()

  transitionComplete: ->
    super

    @world.onReady => @startGame()

  startGame: ->
    @world.start()
    @world.loop.play()

    @player = @world.getItemById 'player'
    @targets = @world.getItemsByAttr 'target'

    @showIntro => @enableControls()

  enableControls: ->
    @world.loop.use => @update()
    @controls = new GameControls @
    @controls.on()

  showIntro: (callback) ->
    @viewportFits = @world.viewport.fits()
    if not @viewportFits
      @world.viewport.followEntity @targets[0], introDuration / 2, =>
        @world.viewport.followEntity @player, introDuration / 2, =>
          callback()
    else callback()

  close: ->
    @elements.restart.off device.getEvent 'click'
    @elements.back.off device.getEvent 'click'

    super

    @controls.off() if @controls?
    @world.stop() if @world?

  update: ->
    if not @viewportFits
      @world.viewport.followEntity @player

module.exports = GameView
