
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
    @game.world.loop.use => @update()

    super

  render: ->
    ctx = width: @viewport.elWidth, height: @viewport.elHeight
    @canvas = $ renderer.render 'game-controls', ctx
    @canvas.hide().appendTo @game.world.stage
    @ctx = @canvas[0].getContext '2d'
    $.extend @ctx, style

  update: ->
    @clearLast()
    if @flicking
      center = @viewport.worldToScreen @game.player.position()
      vertex = @getRelativeMouse()
      @ctx.beginPath()
      @ctx.moveTo center.x, center.y
      @ctx.lineTo vertex.x, vertex.y
      @ctx.stroke()
      @lastUpdate =
        x: if center.x < vertex.x then center.x else vertex.x
        y: if center.y < vertex.y then center.y else vertex.y
        width: Math.abs center.x - vertex.x
        height: Math.abs center.y - vertex.y

  clearLast: ->
    if @lastUpdate?
      x = @lastUpdate.x - style.lineWidth
      y = @lastUpdate.y - style.lineWidth
      width = @lastUpdate.width + style.lineWidth * 2
      height = @lastUpdate.height + style.lineWidth * 2
      @ctx.clearRect x, y, width, height
      @lastUpdate = null

  hideCanvas: -> @canvas.hide()

  showCanvas: -> @canvas.show()

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
      @clearLast()
      @flickTarget.body.applyForce dragged.x, dragged.y, 60
      @flicking = false
      @flickTarget = null

module.exports = GameControls
