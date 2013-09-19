
###
## Touchables

This module binds to the device-specific click event to add a .touch-active pseudo-class for
a set duration after triggering It's applied to the targeted selectors and used to customise visual
feedback when elemements are tapped
###

device = require '../core/device'

touchables = 'a, .button, button, input, .touchable'  # Targeted selector
classNames = touchActive: 'touch-active'              # Custom pseudo-classes
activeStateDuration = 200                             # Milliseconds the class is applied for

module.exports =
  
  initialise: -> @bind()

  bind: ->
    self = @
    # Delegate click event on targeted elements
    $('body').on device.getEvent('click'), touchables, -> self.onClick $ @

  onClick: (element) ->
    # Add custom class-name
    element.addClass classNames.touchActive

    # Attach timed event to remove custom class-name
    element.data 'touchActiveTimer', setTimeout =>
      element.removeClass classNames.touchActive
      if element.data('touchActiveTimer')?
        clearTimeout element.data('touchActiveTimer')
    , activeStateDuration
