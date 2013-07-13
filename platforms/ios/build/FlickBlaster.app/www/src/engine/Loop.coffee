
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

  play: =>
    @playing = true
    requestAnimationFrame @next

  pause: => @playing = false

  use: (callback) => @callbacks.push callback

  next: =>
    @getFPS()
    callback() for callback in @callbacks
    if @playing then requestAnimationFrame @next

  getFPS: =>
    if not @lastUpdate then @lastUpdate = new Date().getTime()
    delta = ( new Date().getTime() - @lastCalledTime ) / 1000
    @lastCalledTime = new Date().getTime()
    @fps = 1 / delta

module.exports = Loop