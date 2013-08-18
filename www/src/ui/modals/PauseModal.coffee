
BaseModal = require './BaseModal'
device = require '../../core/device'
views = require '../../core/views'

class PauseModal extends BaseModal
  templateName: 'modal-pause'
  classNames: 'modal-pause'

  constructor: (@wrap, @context, options = {}) ->
    @game = options.game
    @levelName = options.levelName

    @game.world.stop()

    super

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