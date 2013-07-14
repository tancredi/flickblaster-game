
device = require '../core/device'

win = $ window

followEasing = 20

class Viewport

  constructor: (@el, @width, @height) ->
    @scaleRatio = 0
    @x = 0
    @y = 0
    @fitInScreen()
    @elWidth = @el.width()
    @elHeight = @el.height()
    @center()

  center: ->
    screen = device.getSize()
    @moveTo ( screen.width - @elWidth ) / 2, ( screen.height - @elHeight ) / 2

  fitInScreen: ->
    screen = device.getSize()
    @scaleRatio = @width / screen.width
    @el.css width: @width / @scaleRatio, height: @height / @scaleRatio

  moveTo: (x, y, duration = 0, callback = null, ease = false) ->
    if ease and not duration
      newX = @x + ( x - @x ) / followEasing
      newY = @y + ( y - @y ) / followEasing
      if (Math.abs @x - newX) < .1 and (Math.abs @y - newY) < .1
        return
      else
        @x = newX
        @y = newY
    else
      return if @x is x and @y is y
      @x = x
      @y = y

    if not duration
      @el.css x: @x, y: @y
      callback() if callback?
    else
      @el.transition x: @x, y: @y, duration, => callback() if callback?

  worldToScreen: (value) ->
    if typeof value is 'object' and value.x? and value.y?
      return x: (@worldToScreen value.x), y: (@worldToScreen value.y)
    else
      return value / @scaleRatio

  screenToWorld: (value) ->
    if typeof value is 'object' and value.x? and value.y?
      return x: (@screenToWorld value.x), y: (@screenToWorld value.y)
    else
      return value * @scaleRatio

  fits: ->
    screen = device.getSize()
    @elHeight <= screen.height

  followEntity: (target, duration = 0, callback = null) ->
    targetPos = @worldToScreen target.position()

    x = -targetPos.x + @elWidth / 2
    y = -targetPos.y + @elHeight / 2

    screen = device.getSize()

    if @elHeight >= screen.height
      margin = @elHeight - screen.height
      if y > 0 then y = 0
      else if y > -margin then y = -margin

    if @elWidth >= screen.width
      margin = @elWidth - screen.width
      if x > 0 then x = 0
      else if x < -margin then x = -margin

    @moveTo x, y, duration, callback, true

module.exports = Viewport
