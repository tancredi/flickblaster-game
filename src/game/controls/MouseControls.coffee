
device = require '../../core/device'

body = $ 'body'
viewWrap = $ '#view-wrap'

###
## Mouse Controls class

Utility class to quickly bind mouse controls setups
Extend and have access to mouse position and cached mouse events at anytime
###

class MouseControls

  constructor: (@game) ->
    @wrap = @game.world.stage
    @offset = viewWrap.offset() # Coordinates will be offsetted to be relative to view wrap 
    @active = false             # Controls are tracking
    @mouse =                    # Contains current mouse stats
      x: null                   # Current mouse X relative to view
      y: null                   # Current mouse Y relative to view
      down: false               # Mouse is pressed
      dragging: false           # Mouse is being dragged
    @clickStart = null          # The mousedown position
    @lastDrag = null            # Last position while dragging
    @dragOffset = null          # Offset of the current drag
    @preventClick = false       # Avoid bubbling the click E.g. Used during a drag

  # Enable controls
  on: ->
    @active = true
    @bind()

  # Disable controls
  off: ->
    @active = false
    @reset()

  # Unbind mouse events
  reset: ->
    @wrap.off (device.getEvent 'mousemove')
    @wrap.off (device.getEvent 'mousedown')
    @wrap.off (device.getEvent 'mouseup')
    @wrap.off (device.getEvent 'tap')

  # Bind mouse events
  bind: ->
    self = @
    @wrap.on (device.getEvent 'mousemove'), (e) => if @active then @mouseMove e
    @wrap.on (device.getEvent 'mousedown'), (e) => if @active then @mouseDown e
    @wrap.on (device.getEvent 'mouseup'), (e) => if @active then @mouseUp e
    @wrap.on (device.getEvent 'tap'), (e) => if @active and not @preventClick then @click ($ e.target), e

  # Update x and y in the mouse stats
  updateMousePosition: (e) ->
    moved = @getMouseEvent e
    @mouse.x = moved.pageX
    @mouse.y = moved.pageY

  # Bound to 'mousedown'
  mouseDown: (e) ->
    @preventClick = false
    @updateMousePosition e
    @clickStart = x: @mouse.x, y: @mouse.y
    @mouse.down = true

  # Bound to 'mousemove'
  mouseMove: (e) ->
    if @mouse.dragging
      @dragOffset = @getDragOffset()
      @lastDrag = x: @mouse.x, y: @mouse.y
      @dragMove @dragOffset.last, @dragOffset.total, e
    else if @clickStart? and @mouse.down
      moved = (Math.abs @clickStart.x - @mouse.x) + (Math.abs @clickStart.y - @mouse.y)
      if moved > 1
        @lastDrag = @clickStart
        @mouse.dragging = true
        @dragStart e

    @updateMousePosition e

  # Bound to 'mouseup'
  mouseUp: (e) ->
    if @mouse.dragging
      dragOffset = @getDragOffset()
      @mouse.dragging = false
      @dragStop dragOffset.last, dragOffset.total, e
    @mouse.down = false

  click: (target, e) ->

  # Get the offset of the current drag
  getDragOffset: ->
    if not @mouse.dragging then return null
    last =
      x: @mouse.x - @lastDrag.x
      y: @mouse.y - @lastDrag.y
    total =
      x: @lastDrag.x - @clickStart.x
      y: @lastDrag.y - @clickStart.y
    return { last, total }

  # Called when drag started
  dragStart: (e) -> @preventClick = true

  # Called when drag moved
  dragMove: (lastOffset, totalOffset, e) ->

  # Called when drag stopped
  dragStop: (e) ->

  # Get mouse position relative to viewport
  getRelativeMouse: ->
    screen = device.getSize()
    pos =
      x: @mouse.x - @offset.left - @viewport.x
      y: @mouse.y - @offset.top - @viewport.y
    return pos

  # Normalise mouse and touch events
  getMouseEvent: (e) ->
    if (_.has e, 'pageX') and (_.has e, 'pageY')
      return e
    else if _.has e.originalEvent, 'touches'
      return e.originalEvent.touches[0]
    else
      return pageX: 0, pageY: 0, target: null

module.exports = MouseControls
