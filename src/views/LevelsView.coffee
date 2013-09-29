
BaseView = require '../core/BaseView'
views = require '../core/views'
device = require '../core/device'
renderer = require '../core/renderer'

getByRole = (require '../helpers/dom').getByRole

gameData = require '../game/utils/gameData'
userData = require '../game/utils/userData'

BaseModal = require '../ui/modals/BaseModal'

selectors = locked: '.locked'

viewWrap = $ '#view-wrap'

###
## Levels View

View containing information about user progress and levels navigation
###

class LevelsView extends BaseView
  templateName: 'levels'
  fixHeight:    true
  classNames:   'view-levels'

  constructor: ->
    super

    @context.levels = []

    # Load level progress from userData module
    levelsProgress = userData.getLevelsProgress()

    # Iterate through levels loaded through gameData module and build the context for the template
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
    @elements.nav = home: getByRole 'nav-home', @elements.main

  bind: =>
    super

    # Show game completion modal if game has been completed but not notified
    if localStorage.gameCompleted and not localStorage.gameCompletionNotified
      @notifyGameCompletion()

    # Bind click on level elements
    self = @
    @elements.levels.not(selectors.locked).on (device.getEvent 'click'), (e) ->
      e.preventDefault()
      self.openLevel ($ @).attr 'data-level-name'

    # Bind back to home button
    @elements.nav.home.on (device.getEvent 'click'), (e) ->
      e.preventDefault()
      views.open 'home', 'slide-left'

  notifyGameCompletion: ->
    modalContext =
      title: 'Well done!'
      icon: 'trophy'

    modalOptions =
      templateName: 'modal-completed-game'
      classNames: 'modal-completed-game'

    new BaseModal viewWrap, modalContext, modalOptions
    localStorage.gameCompletionNotified = true

  # Start the game on the specified level (Opens Game View with chosen level name)
  openLevel: (levelName) -> views.open 'game', 'slide-right', null, false, levelName

module.exports = LevelsView
