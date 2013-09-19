
BaseModal = require './BaseModal'
device = require '../../core/device'
views = require '../../core/views'
gameData = require '../../engine/gameData'

# Delay in milliseconds of the stars animations after opening
animationsDelay = 600

# Star elements selector
selectors = star: '.star'

###
## End of Game Modal class

Shown at the end of every game
Displays a different set of elements and actions depending on the outcome of the game

Read BaseModal for more
###

class EndGameModal extends BaseModal
  templateName: 'modal-end-game'
  classNames: 'modal-end-game'

  constructor: (@wrap, @context, options = {}) ->
    @game = options.game            # Parent Game instance
    @starsCount = options.stars     # Stars gained during the game
    @levelName = options.levelName  # Name of the completed level

    # Gets stored data about all levels
    levels = gameData.get 'levels'

    # Finds level and gets next level data, if any
    # Used to show Next Level button

    nextLevel = null

    for level, i in levels
      if level.name is @levelName
        @nextLevel = levels[i + 1] if levels[i + 1]
        break

    super

  # Delegates all actions to all possible triggers shown in the modal
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

  # Animates the stars popping out
  addStars: ->
    # Find all stars that were rendered
    @stars = @inner.find selectors.star
    @addedStars = 0
    @animatedStars = 0

    # Add each animation with a different delay
    for i in [ 1..@starsCount ]
      setTimeout ( => @addStar() ), animationsDelay / 3 * (i - 1)

  # Animate next hidden star popping out
  addStar: ->
    el = @stars.eq @addedStars
    return if not el?
    el.css scale: 4
    @addedStars++
    el.transition opacity: 1, scale: 1, animationsDelay, =>
      @animatedStars++
      if @animatedStars is @starsCount then @starsAdded()

  # Callback called at the end of the stars animation 
  starsAdded: -> # TBD

module.exports = EndGameModal
