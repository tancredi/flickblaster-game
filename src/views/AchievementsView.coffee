
BaseView = require '../core/BaseView'
device = require '../core/device'

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

  bind: ->
    super

module.exports = AchievementsView
