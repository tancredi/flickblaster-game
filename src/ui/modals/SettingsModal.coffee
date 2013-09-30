
device = require '../../core/device'

BaseModal = require './BaseModal'

sounds = require '../../game/utils/sounds'

viewWrap = $ '#view-wrap'

classNames =
  switchOn: 'on'
  ready: 'ready'

###
## Settings Modal class

Modal called from game and home to change user settings
###

class SettingsModal extends BaseModal
  templateName: 'partials/modal-settings'
  classNames: 'modal-settings'

  constructor: (wrap) ->
    options =
      title: 'Settings'
      icon: 'cog'

    super viewWrap, options

  getElements: ->
    @elements =
      audioSwitch: @el.find '[data-role="sound"]'

  # Delegate actions to all buttons
  render: ->
    super

    @getElements()
    @initSound()

    @elements.audioSwitch.on (device.getEvent 'mousedown'), (e) =>
      @toggleSound()
      e.preventDefault()

  soundIsOn: ->
    if localStorage.sound
      return JSON.parse localStorage.sound
    else
      return true

  initSound: ->
    soundSet = @soundIsOn() or true
    @updateSound()
    setTimeout ( =>
      @elements.audioSwitch.addClass classNames.ready
      ), 1

  toggleSound: ->
    localStorage.sound = (not @soundIsOn()) or false
    @updateSound()

  updateSound: ->
    soundSet = @soundIsOn()
    @elements.audioSwitch.toggleClass classNames.switchOn, soundSet
    if soundSet then sounds.on() else sounds.off()

module.exports = SettingsModal
