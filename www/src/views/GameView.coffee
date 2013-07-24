
BaseView = require '../core/BaseView'
getByRole = (require '../helpers/dom').getByRole
device = require '../core/device'
debug = require '../core/debug'
phys = require '../helpers/physics'
World = require '../engine/World'
GameControls = require '../engine/GameControls'
views = require '../core/views'
EndGameModal = require '../ui/modals/EndGameModal'
userData = require '../engine/userData'

win = $ window

introDuration = if debug.skipAnimations then 0 else 2400

class GameView extends BaseView
  templateName: 'game'
  classNames: 'view-game'
  fixHeight: true

  constructor: (@levelName) ->
    super

    @shots = null
    @targets = null
    @stars = 3

  getElements: ->
    super

    @elements.restart = getByRole 'restart', @elements.main
    @elements.back = getByRole 'back', @elements.main
    @elements.shots = getByRole 'shots-counter', @elements.main

  bind: ->
    super

    @world = new World @elements.main, @levelName

    @elements.restart.on (device.getEvent 'click'), (e) =>
      @restart()
      e.preventDefault()

    @elements.back.on (device.getEvent 'click'), (e) =>
      views.open 'levels', 'pop-out'
      e.preventDefault()

    (_ @world).on 'shoot', => @setShots @shots - 1
    (_ @world).on 'pot', => @setTargets @targets - 1

  restart: -> views.open 'game', null, null, false, @levelName

  transitionComplete: ->
    super

    @world.onReady => @startGame()

  startGame: ->
    @world.start()
    @world.loop.play()

    @player = @world.getItemById 'player'
    @targets = @world.getItemsByAttr 'target'

    @setShots @world.level.data.shots
    @setTargets @targets.length

    @showIntro => @enableControls()

  setTargets: (amt) ->
    @targets = amt
    if amt is 0 then @finish()

  finish: ->
    context = title: 'Level Complete!'
    options = stars: @stars, game: @
    userData.saveLevelScore @levelName, @stars
    new EndGameModal @elements.main, context, options

  setShots: (amt) ->
    @shots = amt
    if amt < -2 then @setStars 0
    else if amt < -1 then @setStars 1
    else if amt < 0 then @setStars 2
    @elements.shots.text amt

  setStars: (amt) ->
    if @stars isnt amt
      @elements.shots.removeClass "stars-#{@stars}"
      @stars = amt
      @elements.shots.addClass "stars-#{@stars}"

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
