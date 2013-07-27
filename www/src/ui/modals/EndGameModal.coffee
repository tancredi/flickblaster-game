
BaseModal = require './BaseModal'
device = require '../../core/device'
views = require '../../core/views'

animationsDelay = 600

selectors = star: '.star'

class EndGameModal extends BaseModal
  templateName: 'modal-end-game'
  classNames: 'modal-end-game'

  constructor: (@wrap, @context, options = {}) ->
    @starsCount = options.stars
    @game = options.game

    super

  bind: ->
    super

    @inner.on (device.getEvent 'click'), '[data-role="restart"]', (e) =>
      @game.restart()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="next"]', (e) =>
      @nextLevel()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="back"]', (e) =>
      views.open 'levels', 'slide-left'
      e.preventDefault()

    @addStars()

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