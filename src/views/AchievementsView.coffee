
BaseView = require '../core/BaseView'
device = require '../core/device'
views = require '../core/views'

getByRole = (require '../helpers/dom').getByRole

achievements = require '../game/utils/achievements'

###
## Achievements View class

Shows available and unlocked achievements
###

class AchievementsView extends BaseView
  templateName: 'achievements'
  classNames:   'view-achievements'
  fixHeight:    true

  render: (wrapper) ->
    @context.achievements = achievements.getAll()

    super

  getElements: ->
    super

    @elements.nav = home: getByRole 'nav-home', @elements.main

  bind: ->
    super

    # Bind back to home button
    @elements.nav.home.on (device.getEvent 'click'), (e) ->
      e.preventDefault()
      views.open 'home', 'slide-left'

module.exports = AchievementsView
