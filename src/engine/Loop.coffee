
###
Loop class

Based on a requestAnimationFrame polyfill, it handles the loop at the very core of the game
Callbacks may be called at a different frequencies depending on device performance
###

# requestAnimationFrame polyfill
requestAnimationFrame =
  window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame or
  window.oRequestAnimationFrame or
  window.msRequestAnimationFrame or
  (callback) -> window.setTimeout callback, 1000 / 60
  
class Loop

  constructor: ->
    @callbacks = []
    @playing = false
    @fps = 0

  # Run the loop
  play: =>
    @playing = true
    requestAnimationFrame @next

  # Pause the loop
  pause: => @playing = false

  # Attach a callback to .next
  use: (callback) => @callbacks.push callback

  # Called at every iteration
  next: =>
    @getFPS()
    callback() for callback in @callbacks
    if @playing then requestAnimationFrame @next

  # Get framerate based on delay since last iteration
  getFPS: =>
    if not @lastUpdate then @lastUpdate = new Date().getTime()
    delta = ( new Date().getTime() - @lastCalledTime ) / 1000
    @lastCalledTime = new Date().getTime()
    @fps = 1 / delta

module.exports = Loop
