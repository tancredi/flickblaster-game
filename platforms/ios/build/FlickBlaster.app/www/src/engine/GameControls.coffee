
MouseControls = require './MouseControls'
renderer = require '../core/renderer'
phys = require '../helpers/physics'

style =
  lineCap: 'round'
  strokeStyle: '#db7c52'
  lineWidth: 5

class GameControls extends MouseControls

  constructor: (@game) ->
    @viewport = @game.world.viewport
    @render()

    super @game.elements.main

  render: ->
    ctx = width: @viewport.elWidth, height: @viewport.elHeight
    @canvas = $ renderer.render 'game-controls', ctx
    @canvas.hide().appendTo @game.world.stage
    @ctx = @canvas[0].getContext '2d'
    $.extend @ctx, style

  clearCanvas: -> @ctx.clearRect 0, 0, @viewport.elWidth, @viewport.elHeight

  hideCanvas: -> @canvas.stop().fadeOut()

  showCanvas: -> @canvas.stop().fadeIn()

  dragStart: (e) ->
    super

    evt = @getMouseEvent e
    entity = ($ evt.target).data 'entity'

    if entity? and entity.id is 'player'
      @showCanvas()
      @flicking = true
      @flickTarget = entity

  dragStop: ->
    super

    if @flicking
      center = @viewport.worldToScreen @game.player.position()
      vertex = @getRelativeMouse()
      dragged = x: center.x - vertex.x, y: center.y - vertex.y
      @hideCanvas()
      @clearCanvas()
      @flickTarget.body.applyForce dragged.x, dragged.y, 60
      @flicking = false
      @flickTarget = null

  dragMove: ->
    @clearCanvas()
    if @flicking
      center = @viewport.worldToScreen @game.player.position()
      vertex = @getRelativeMouse()
      @ctx.beginPath()
      @ctx.moveTo center.x, center.y
      @ctx.lineTo vertex.x, vertex.y
      @ctx.stroke()

module.exports = GameControls