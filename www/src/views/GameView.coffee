
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

  constructor: (@levelName) ->
    super

  bind: ->
    super()

    @world = new World @elements.main, @levelName
    @world.onReady => @startGame()

    (getByRole 'restart', @elements.main).on 'click', (e) =>
      views.open 'game', null, null, false, @levelName
      e.preventDefault()

    (getByRole 'back', @elements.main).on 'click', (e) =>
      views.open 'levels', 'pop-out'
      e.preventDefault()

  startGame: ->
    @world.start()
    @world.loop.play()

    @player = @world.getItemById 'player'
    @targets = @world.getItemsByAttr 'target'

    @showIntro => @enableControls()

  enableControls: ->
    @world.loop.use @update
    @controls = new GameControls @
    @controls.on()

  showIntro: (callback) ->
    @viewportFits = @world.viewport.fits()
    if not @viewportFits
      @world.viewport.followEntity @targets[0], introDuration / 2, =>
        @world.viewport.followEntity @player, introDuration / 2, =>
          callback()
    else callback()

  update: =>
    if not @viewportFits
      @world.viewport.followEntity @player

module.exports = GameView
