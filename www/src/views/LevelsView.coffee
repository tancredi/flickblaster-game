
BaseView = require '../core/BaseView'
getByRole = (require '../helpers/dom').getByRole
zeroPad = (require '../helpers/string').zeroPad
views = require '../core/views'

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
    @elements.levels.on 'click', -> self.openLevel ($ @).attr 'data-level-name'

  openLevel: (levelName) ->
    views.open 'game', 'pop-in'

module.exports = LevelsView
