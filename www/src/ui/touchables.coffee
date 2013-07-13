
device = require '../core/device'

touchables = 'a, .button, button, input, .touchable, .clickable'
classNames = touchActive: 'touch-active'
activeStateDuration = 200

module.exports =
  
  initialise: -> @bind()

  bind: ->
    self = @
    $('body').on 'click touchend', touchables, -> self.onClick $ @

  onClick: (element) ->
    element.addClass classNames.touchActive

    element.data 'touchActiveTimer', setTimeout =>
      element.removeClass classNames.touchActive
      if element.data('touchActiveTimer')?
        clearTimeout element.data('touchActiveTimer')
    , activeStateDuration