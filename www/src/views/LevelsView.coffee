
BaseView = require '../core/BaseView'
views = require '../core/views'
device = require '../core/device'
getByRole = (require '../helpers/dom').getByRole
zeroPad = (require '../helpers/string').zeroPad
gameData = require '../engine/gameData'
userData = require '../engine/userData'

class LevelsView extends BaseView
  templateName: 'levels'
  fixHeight: true
  classNames: 'view-levels'

  constructor: ->
    super

    @context.levels = []

    levelsProgress = userData.getLevelsProgress()

    for level, i in gameData.get 'levels'
      stars = []
      for n in [0..2]
        if levelsProgress[i].stars > n
          stars.push scored: true
        else
          stars.push scored: false

      @context.levels.push
        index: i + 1
        name: level.name
        completed: levelsProgress[i].completed
        perfect: if levelsProgress[i] is 3 then true else false
        stars: stars
        locked: levelsProgress[i].locked

  getElements: =>
    super

    @elements.levels = getByRole 'level', @elements.main

  bind: =>
    super

    self = @
    @elements.levels.on (device.getEvent 'click'), -> self.openLevel ($ @).attr 'data-level-name'

  openLevel: (levelName) -> views.open 'game', 'slide-right', null, false, levelName

module.exports = LevelsView
