
BaseModal = require './BaseModal'
device = require '../../core/device'
views = require '../../core/views'
gameData = require '../../engine/gameData'

animationsDelay = 600

selectors = star: '.star'

class EndGameModal extends BaseModal
  templateName: 'modal-end-game'
  classNames: 'modal-end-game'

  constructor: (@wrap, @context, options = {}) ->
    @starsCount = options.stars
    @game = options.game
    @levelName = options.levelName

    levels = gameData.get 'levels'
    nextLevel = null

    for level, i in levels
      if level.name is @levelName
        @nextLevel = levels[i + 1] if levels[i + 1]
        break

    super

  bind: ->
    super

    @inner.on (device.getEvent 'click'), '[data-role="restart"]', (e) =>
      @game.restart()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="next"]', (e) =>
      @openNextLevel()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="back"]', (e) =>
      views.open 'levels', 'slide-left'
      e.preventDefault()

    @addStars()

  openNextLevel: ->
    views.open 'game', 'slide-right', null, false, @nextLevel.name

  addStars: ->
    @stars = @inner.find selectors.star
    @addedStars = 0
    @animatedStars = 0
    for i in [ 1..@starsCount ]
      setTimeout ( => @addStar() ), animationsDelay / 3 * (i - 1)

  addStar: ->
    el = @stars.eq @addedStars
    return if not el?
    el.css scale: 4
    @addedStars++
    el.transition opacity: 1, scale: 1, animationsDelay, =>
      @animatedStars++
      if @animatedStars is @starsCount then @starsAdded()

  starsAdded: ->

module.exports = EndGameModal