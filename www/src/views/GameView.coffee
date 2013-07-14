
BaseView = require '../core/BaseView'
getByRole = require('../helpers/dom').getByRole
device = require '../core/device'
debug = require '../core/debug'
phys = require '../helpers/physics'
World = require '../engine/World'
GameControls = require '../engine/GameControls'
entityFx = require '../helpers/entityFx'

win = $ window

introDuration = if debug.skipAnimations then 0 else 2400

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

    @player.onCollisionStart @target, => @win()

    @showIntro => @enableControls()

  win: ->
    dist = @player.distance @target, false
    @player.body.applyForce dist.x, dist.y, -40
    @player.body.setDrag 10
    entityFx.stopAndPop @player

  enableControls: ->
    @world.loop.use @update
    @controls = new GameControls @
    @controls.on()

  showIntro: (callback) ->
    @viewportFits = @world.viewport.fits()
    if not @viewportFits
      @world.viewport.followEntity @target, introDuration / 2, =>
        @world.viewport.followEntity @player, introDuration / 2, =>
          callback()
    else callback()

  update: =>
    if not @viewportFits
      @world.viewport.followEntity @player

module.exports = GameView
