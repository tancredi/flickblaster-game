
BaseModal = require './BaseModal'
device = require '../../core/device'

userData = require '../../game/utils/userData'
gameData = require '../../game/utils/gameData'

###
## Tutorial Modal class

Shown once with custom message
###

class TutorialModal extends BaseModal
  templateName: 'partials/modal-tutorial'
  classNames: 'modal-tutorial'

  constructor: (@wrap, @id) ->
    @context = gameData.get 'tutorials', @id

    # Only open if tutorial wasn't seen already
    if (userData.getSeenTutorials().indexOf @id) is -1
      super @wrap, @context

  # Delegate actions to all buttons
  bind: ->
    super

    @inner.on (device.getEvent 'click'), '[data-role="done"]', (e) =>
      @done()
      e.preventDefault()

  done: ->
    userData.saveSeenTutorial @id
    @close()

module.exports = TutorialModal
