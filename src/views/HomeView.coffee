
BaseView = require '../core/BaseView'
device = require '../core/device'
views = require '../core/views'

getByRole = (require '../helpers/dom').getByRole

userData = require '../game/utils/userData'
gameData = require '../game/utils/gameData'

# Cache jQuery-wrapped window object
win = $ window

###
## Home View class

The first view shown when the app is started
###

class HomeView extends BaseView
  templateName: 'home'
  classNames:   'view-home'
  fixHeight:    true

  constructor: (@levelName) ->
    super

  getElements: ->
    super

    @elements.nav =
      play: getByRole 'nav-play', @elements.main         # Pause button
      levels: getByRole 'nav-levels', @elements.main # Shots display

  bind: ->
    super

    nextLevel = @getNextLevel()

    @elements.nav.play.on device.getEvent('click'), (e) ->
      e.preventDefault()
      views.open 'game', 'pop-out', null, false, nextLevel.name

    @elements.nav.levels.on device.getEvent('click'), (e) ->
      e.preventDefault()
      views.open 'levels', 'slide-right'

  getNextLevel: ->
    levelIndex = null
    progress = userData.getLevelsProgress()

    for level, i in progress
      break if level.locked
      levelIndex = i

    levels = gameData.get 'levels'
    return levels[levelIndex]

module.exports = HomeView
