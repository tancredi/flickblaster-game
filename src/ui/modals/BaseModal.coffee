
renderer = require '../../core/renderer'
device = require '../../core/device'

transitionTime = 200    # Duration of modal transition in milliseconds

# Selectors used in this class
selectors =
  inner: '.modal'
  overlay: '.overlay'

templates =
   modal: 'partials/modal'

###
## Base Modal class

Extend this class to create a custom modal.
Instanciate the class to render and open the modal

Class-based modals may not necessarily be a great idea,
but hey, I wanted to try a new approach.
Deal with it.
###

class BaseModal
  templateName: 'partials/modal-foo' # Customise this property to render a different template
  classNames: ''            # Custom classnames for the inner element
  showClose: true           # Will render a close button if true

  constructor: (@wrap, @context, options = {}) ->
    @onClose = options.onClose or null  # Callback triggered when .close() is called
    @onOpen = options.onOpen or null    # Callback triggered when .open() is called

    # Overwrite modal template and classnames if specified in options

    if options.templateName
      @templateName = options.templateName

    if options.classNames
      @classNames = options.classNames

    @open()

  # Render modal body template
  render: ->
    body = renderer.render @templateName, @context
    context = $.extend @context, body: body, 'show-close': @showClose

    # Render modal wrap
    @el = $ renderer.render templates.modal, context

    # Find pre-existing overlay element
    @overlay = @el.find selectors.overlay

    # Get inner element from wrap and add custom classes
    @inner = @el.find selectors.inner
    @inner.addClass @classNames

  open: ->
    @render()

    # Prepare overlay and inner element for opening transition
    @overlay.add(@inner).css opacity: 0
    @el.appendTo @wrap
    @inner.css
      x: ( @wrap.width() - @inner.outerWidth() ) / 2
      y: ( @wrap.height() - @inner.outerHeight() ) / 2
      scale: .5

    # Start opening transition
    @overlay.transition opacity: 1, transitionTime / 2
    @inner.transition scale: 1, opacity: 1, transitionTime, =>
      # Bind events and trigger .onOpen callback
      @bind()
      @onOpen @ if @onOpen?

  # Called after opening transition is over
  bind: ->
    @inner.on (device.getEvent 'click'), '[data-role="close"]', (e) =>
      e.preventDefault()
      @close()

  # Start closing transition
  close: (callback) ->
    @overlay.transition opacity: 0, transitionTime / 2
    @inner.transition scale: .5, opacity: 0, transitionTime, =>
      # Remove elements and trigger .onClose callback
      @el.remove()
      @onClose @ if @onClose?

module.exports = BaseModal
