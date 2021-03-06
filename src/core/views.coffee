
###
## Views module

Stores, instanciates, animates and handles views
###

renderer = require './renderer'
device = require './device'
getByRole = (require '../helpers/dom').getByRole
transitions = require './viewTransitions'

win = $ window
viewWrap = $ '#view-wrap'

module.exports =

  wrap: $ '#view-wrap'  # Element that views will be render in
  current: null         # Active view (Open and focused)
  shown: []             # All shown views (Open)
  views: {}             # Object containing loaded views

  # Initialises views wrapper based on device screen size
  init: ->
    viewWrap.css overflow: 'hidden'
    @resize()

    @bindFullscreen()

    win.on 'resize', => @resize()

  # Hide the address bar on windows load (Needed for mobile)
  bindFullscreen: ->
    window.addEventListener "load", =>
      setTimeout ( =>
        device.resize()
      ), 0

  resize: ->
    screen = device.getSize()

    if device.isFakeSize()
      x = (window.outerWidth - screen.width) / 2
      y = (window.outerHeight - screen.height) / 2
    else
      x = 0
      y = 0

    viewWrap.css
      width: screen.width
      height: screen.height
      left: x + device.getOffset().x
      top: y + device.getOffset().y

  # Close all views
  closeAll: -> getByRole('view', @wrap).remove()

  # Store view in @views under a namespace
  load: (ns, view) ->
    if typeof ns is 'object'
      routes = ns
      @load ns, view for ns, view of routes
    else @views[ns] = view

  # Instanciate and open view given its namespace - performing specified transition
  open: (ns, transition = null, callback = null, openOnTop = false, options = {}) ->
    if not openOnTop then @shown = []
    if transition? and @animating then return false

    if @current? then @current.unbind()

    if typeof ns is 'object'
      view = ns
    else
      view = new @views[ns] options

    if not view.elements? then view.render @wrap
    else view.show()

    if transition? and _.has @transitions, transition
      @applyTransition view, transition, callback, openOnTop
    else
      @onShown view, callback, openOnTop

    return view

  # Perform transition between old and new views, restore elements CSS at the end
  applyTransition: (view, transition, callback = null, openOnTop = false) ->
    @animating = true
    oldViewStyle = @current.elements.main.attr 'style'
    newViewStyle = view.elements.main.attr 'style'
    wrapStyle = @wrap.attr 'style'

    @transitions[transition] view, @current, =>
      @animating = false
      @onShown view, callback, openOnTop

      @current.elements.main.stop()
      view.elements.main.stop()

      if oldViewStyle then @current.elements.main.attr 'style', oldViewStyle
      else @current.elements.main.removeAttr 'style'

      if newViewStyle then view.elements.main.attr 'style', newViewStyle
      else view.elements.main.removeAttr 'style'

      @wrap.attr 'style', wrapStyle

  # Fires after a view is shown
  onShown: (view, callback = null, openOnTop = false) ->
    view.transitionComplete()
    if not openOnTop
      if @current? then @current.close()
    else
      @current.hide()
    @shown.push view
    @current = view

    if callback? then callback view

  # Loaded transitions
  transitions: transitions
