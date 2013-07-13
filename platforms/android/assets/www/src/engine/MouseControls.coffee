
device = require '../core/device'

body = $ 'body'

class MouseControls

  constructor: (@wrap) ->
    @active = false
    @mouse = x: null, y: null, down: false, dragging: false
    @clickStart = null
    @lastDrag = null
    @dragOffset = null
    @preventClick = false

  on: ->
    @active = true
    @bind()

  off: ->
    @active = false
    @reset()

  reset: ->
    @wrap.off (device.getEvent 'mousemove')
    @wrap.off (device.getEvent 'mousedown')
    @wrap.off (device.getEvent 'mouseup')
    @wrap.off (device.getEvent 'tap')

  bind: ->
    self = @
    @wrap.on (device.getEvent 'mousemove'), (e) => if @active then @mouseMove e
    @wrap.on (device.getEvent 'mousedown'), (e) => if @active then @mouseDown e
    @wrap.on (device.getEvent 'mouseup'), (e) => if @active then @mouseUp e
    @wrap.on (device.getEvent 'tap'), (e) => if @active and not @preventClick then @click ($ e.target), e

  updateMousePosition: (e) ->
    moved = @getMouseEvent e
    @mouse.x = moved.pageX
    @mouse.y = moved.pageY

  mouseDown: (e) ->
    @preventClick = false
    @updateMousePosition e
    @clickStart = x: @mouse.x, y: @mouse.y
    @mouse.down = true

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

  mouseUp: (e) ->
    if @mouse.dragging
      dragOffset = @getDragOffset()
      @mouse.dragging = false
      @dragStop dragOffset.last, dragOffset.total, e
    @mouse.down = false

  click: (target, e) ->

  getDragOffset: ->
    if not @mouse.dragging then return null
    last =
      x: @mouse.x - @lastDrag.x
      y: @mouse.y - @lastDrag.y
    total =
      x: @lastDrag.x - @clickStart.x
      y: @lastDrag.y - @clickStart.y
    return { last, total }

  dragStart: (e) -> @preventClick = true

  dragMove: (lastOffset, totalOffset, e) ->

  dragStop: (e) ->

  getRelativeMouse: ->
    wrapOffset = @wrap.offset()
    pos =
      x: @mouse.x - wrapOffset.left
      y: @mouse.y - wrapOffset.top
    return pos

  getMouseEvent: (e) ->
    if (_.has e, 'pageX') and (_.has e, 'pageY')
      return e
    else if _.has e.originalEvent, 'touches'
      return e.originalEvent.touches[0]
    else
      return pageX: 0, pageY: 0, target: null

module.exports = MouseControls
