
BaseModal = require './BaseModal'
device = require '../../core/device'
views = require '../../core/views'

###
## Pause Modal class

Modal shown when pausing
Read BaseModal for more
###

class PauseModal extends BaseModal
  templateName: 'modal-pause'
  classNames: 'modal-pause'

  constructor: (@wrap, @context, options = {}) ->
    @game = options.game            # Parent GameView instance
    @levelName = options.levelName  # Name of the level currently played

    # 'Pause' the world physics and updates
    @game.world.stop()

    super

  # Delegate actions to all buttons
  bind: ->
    super

    @inner.on (device.getEvent 'click'), '[data-role="restart"]', (e) =>
      @game.restart()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="resume"]', (e) =>
      @close()
      @game.world.play()
      e.preventDefault()

    @inner.on (device.getEvent 'click'), '[data-role="back"]', (e) =>
      views.open 'levels', 'slide-left'
      e.preventDefault()

module.exports = PauseModal