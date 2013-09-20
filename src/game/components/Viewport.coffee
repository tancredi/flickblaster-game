
device = require '../../core/device'

win = $ window

# Amount of easing applied when panning to follow a game item
followEasing = 20

topPadding = 18

###
## Viewport Class

Contains game view elements on its wrapping elements, takes care of panning them into the screen
after adapting to the screen size, it also takes care of translating screen coordinates into game
coordinates and vice-versa

This conversion is used by all modules that deal with rendering, and allows dealing with game
logic, physics and measurement with better flexibility and ease
###

class Viewport

  constructor: (@el, @width, @height) ->
    @scaleRatio = 0             # Stored for translations within game and screen coordinates
    @x = 0                      # Viewport X position
    @y = 0                      # Viewport Y position
    @screen = device.getSize()  # Screen size

    @fitInScreen()
    @elWidth = @el.width()
    @elHeight = @el.height()
    @center()

  # Center the viewport of game stage
  center: -> @moveTo ( @screen.width - @elWidth ) / 2, ( @screen.height - @elHeight ) / 2

  # Scale to fit horizontally on the screen size
  fitInScreen: ->
    @scaleRatio = @width / @screen.width
    if @height / @scaleRatio + topPadding > @screen.height
      @scaleRatio = @height / (@screen.height - topPadding * 2)

    @el.css width: @width / @scaleRatio, height: @height / @scaleRatio

  # Set stage position absolutely - animate and ease if specified
  moveTo: (x, y, duration = 0, callback = null, ease = false) ->
    # Only appy easing if animating
    if ease and not duration
      newX = @x + ( x - @x ) / followEasing
      newY = @y + ( y - @y ) / followEasing
      if (Math.abs @x - newX) < .1 and (Math.abs @y - newY) < .1
        return
      else
        @x = newX
        @y = newY
    else
      # Avoids manipulating if no real change is applied
      # Huge save in performance if updating viewport every frame
      return if @x is x and @y is y
      @x = x
      @y = y

      y = @y + topPadding / 2

    # Using Transit.js (For 3D Transforms and transitions) to access hardware acceleration
    # and avoid thre constant re-draw of children elements

    # Apply CSS transformation if not animating
    # Otherwise animate it with CSS translation
    if not duration
      @el.css x: @x, y: y
      callback() if callback?
    else
      @el.transition x: @x, y: y, duration, => callback() if callback?

  # Translate world coordinates into screen coordinates
  worldToScreen: (value) ->
    if typeof value is 'object' and value.x? and value.y?
      return x: (@worldToScreen value.x), y: (@worldToScreen value.y)
    else
      return value / @scaleRatio

  # Translate screen coordinates into world coordinates
  screenToWorld: (value) ->
    if typeof value is 'object' and value.x? and value.y?
      return x: (@screenToWorld value.x), y: (@screenToWorld value.y)
    else
      return value * @scaleRatio

  # Returns true if the whole height is shown (Useful if scaled to fit horizontally)
  fits: -> @elHeight <= @screen.height

  followEntity: (target, duration = 0, callback = null) ->
    targetPos = @worldToScreen target.position()

    x = - targetPos.x + @screen.width / 2
    y = - targetPos.y + @screen.height / 2

    # Caps X position not to show blank space
    if @elHeight >= @screen.height
      margin = @elHeight - @screen.height
      if y > 0 then y = 0
      else if y < -margin then y = -margin

    # Caps Y position not to show blank space
    if @elWidth >= @screen.width
      margin = @elWidth - @screen.width
      if x > 0 then x = 0
      else if x < -margin then x = -margin

    @moveTo x, y, duration, callback, true

module.exports = Viewport
