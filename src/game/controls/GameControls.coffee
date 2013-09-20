
shotStrength = 2

renderer = require '../../core/renderer'

phys = require '../utils/physics'
MouseControls = require './MouseControls'

# Style of the line rendered to display visual feedback of the dragging
style =
  lineCap: 'round'
  strokeStyle: '#db7c52'
  lineWidth: 5

###
## Game Controls Class

Handles the binding, handling and UI of the game controls
Read MouseControls for DOM bindings
###

class GameControls extends MouseControls

  constructor: (@game) ->
    @viewport = @game.world.viewport
    @render()
    # Add .update to the gameloop
    @game.world.loop.use => @update()

    super

  # Render the UI canvas element in the given World's Viewport
  render: ->
    ctx = width: @viewport.elWidth, height: @viewport.elHeight
    @canvas = $ renderer.render 'game-controls', ctx
    # Hide the UI canvas (Will be displayed when dragging) and get its context
    @canvas.hide().appendTo @game.world.stage
    @ctx = @canvas[0].getContext '2d'
    # Apply style attributes to the canvas
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

  # Clear the the bounding box of last frame's render area if happened
  clearLast: ->
    if @lastUpdate?
      x = @lastUpdate.x - style.lineWidth
      y = @lastUpdate.y - style.lineWidth
      width = @lastUpdate.width + style.lineWidth * 2
      height = @lastUpdate.height + style.lineWidth * 2
      @ctx.clearRect x, y, width, height
      @lastUpdate = null

  hideCanvas: ->
    @canvas.hide()

  showCanvas: ->
    @canvas.show()

  # Called when drag starts
  dragStart: (e) ->
    super

    evt = @getMouseEvent e
    entity = ($ evt.target).data 'entity'

    if entity? and entity.id is 'player'
      @showCanvas()
      @flicking = true
      @flickTarget = entity

  # Called when drag stops
  dragStop: ->
    super

    # Creates force vector and applies it to target when flicked
    if @flicking
      (_ @game.world).emit 'shoot', []
      center = @viewport.worldToScreen @game.player.position()
      vertex = @getRelativeMouse()
      dragged = x: center.x - vertex.x, y: center.y - vertex.y
      dragged = @viewport.screenToWorld dragged
      @hideCanvas()
      @clearLast()
      @flickTarget.body.applyForce -dragged.x, -dragged.y, shotStrength
      @flicking = false
      @flickTarget = null

module.exports = GameControls
