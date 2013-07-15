
BaseView = require '../core/BaseView'
views = require '../core/views'
device = require '../core/device'
getByRole = (require '../helpers/dom').getByRole
zeroPad = (require '../helpers/string').zeroPad

levels = 20

class LevelsView extends BaseView
  templateName: 'levels'
  fixHeight: true
  classNames: 'view-levels'

  constructor: ->
  	super

  	@context.levels = []
  	for i in [ 0..levels ]
  		@context.levels.push index: i + 1, name: zeroPad i + 1, 2

  getElements: =>
    super

    @elements.levels = getByRole 'level', @elements.main

  bind: =>
    super

    self = @
    @elements.levels.on (device.getEvent 'click'), -> self.openLevel ($ @).attr 'data-level-name'

  openLevel: (levelName) -> views.open 'game', 'pop-in', null, false, levelName

module.exports = LevelsView
