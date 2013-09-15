
BaseView = require '../core/BaseView'
views = require '../core/views'
device = require '../core/device'
getByRole = (require '../helpers/dom').getByRole
zeroPad = (require '../helpers/string').zeroPad
gameData = require '../engine/gameData'
userData = require '../engine/userData'

# Levels View - Displays all levels with user progress and 

class LevelsView extends BaseView
  templateName: 'levels'
  fixHeight:    true
  classNames:   'view-levels'

  constructor: ->
    super

    @context.levels = []

    # Load level progress from userData module
    levelsProgress = userData.getLevelsProgress()

    # Iterate through levels and create context for the template
    for level, i in gameData.get 'levels'
      stars = []

      # Add individual stars objects
      for n in [0..2]
        if levelsProgress[i].stars > n
          stars.push scored: true
        else
          stars.push scored: false

      # Add level object to context
      @context.levels.push
        index:      i + 1
        name:       level.name
        completed:  levelsProgress[i].completed
        perfect:    if levelsProgress[i] is 3 then true else false
        stars:      stars
        locked:     levelsProgress[i].locked

  getElements: =>
    super

    # Get level elements
    @elements.levels = getByRole 'level', @elements.main

  bind: =>
    super

    # Bind click on level elements
    self = @
    @elements.levels.on (device.getEvent 'click'), -> self.openLevel ($ @).attr 'data-level-name'

  # Start the game on the specified level (Opens Game View with chosen level name)
  openLevel: (levelName) -> views.open 'game', 'slide-right', null, false, levelName

module.exports = LevelsView
