
# View Transitions - Core transitions and core DOM manipulation

device = require './device'
debug = require './debug'

# Overall duration of all views transition
defaultDuration = if debug.skipAnimations then 0 else 400

# Needed to tweak CSS overflow while moving view elements around
wrap = $ '#view-wrap'

# Absolutely position an element and resize to take all available space
placeAbsolutely = (view) ->
  deviceSize = device.getSize()
  view.elements.main.css
    position: 'absolute'
    top: 0
    left: 0
    width: deviceSize.width
    height: deviceSize.height

# Pop FX base function: Zooms in / out while fading
popView = (scaleFrom, newView, oldView, callback, duration = defaultDuration) ->
  placeAbsolutely newView

  newView.elements.main.css scale: scaleFrom, opacity: 0
  newView.elements.main.transition scale: 1, opacity: 1

  setTimeout ->
    callback newView
  , defaultDuration

# Horizontal Slide FX base function: switch views sliding screen on left / right
horizontalSlide = (dir, newView, oldView, callback, duration = defaultDuration) ->
  deviceSize = device.getSize()

  wrap.css
    width: deviceSize.width
    'overflow-x': 'hidden'
    position: 'relative'

  placeAbsolutely newView
  newView.elements.main.css x: ( 100 * dir) + '%'

  newView.elements.main.transition x: '0', duration

  if oldView?
    oldView.elements.main.css
      width: deviceSize.width
      height: deviceSize.height
    oldView.elements.main.transition x: ( 100 * -dir) + '%', duration, -> callback newView

# Flip FX base function: Rotates the screen on Y axis to reveal new view
flipViews = (newView, oldView, callback) ->
    duration = defaultDuration

    placeAbsolutely newView

    oldView.elements.main.css position: 'relative', 'z-index': 1
    newView.elements.main.css 'z-index': -1, rotateY: '-90deg', z: -500

    oldView.elements.main.transition rotateY: '90deg', duration / 2

    setTimeout ->
      newView.elements.main.transition rotateY: '0deg', duration / 2
    , duration / 2, -> callback newView

module.exports =

  # Horizontal slide FX preset: Left to right
  'slide-right': (newView, oldView, callback) -> horizontalSlide 1, newView, oldView, callback

  # Horizontal slide FX preset: Right to left
  'slide-left': (newView, oldView, callback) -> horizontalSlide -1, newView, oldView, callback

  # Flip FX preset
  'flip': flipViews

  # Pop FX preset: Pops new view zooming out
  'pop-out': (newView, oldView, callback) -> popView 2.2, newView, oldView, callback

  # Pop FX preset: Pops new view zooming in
  'pop-in': (newView, oldView, callback) -> popView .7, newView, oldView, callback
    

    
