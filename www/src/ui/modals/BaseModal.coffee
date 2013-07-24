
renderer = require '../../core/renderer'

modalTemplate = 'modal'
transitionTime = 200

selectors = inner: '.modal', overlay: '.overlay'

class BaseModal
  templateName: 'modal-foo'

  constructor: (@wrap, @context, options = {}) ->
    @onClose = options.onClose or null
    @onOpen = options.onOpen or null
    @open()

  render: ->
    body = renderer.render @templateName, @context
    @el = $ renderer.render modalTemplate, $.extend @context, body: body
    @overlay = @el.find selectors.overlay
    @inner = @el.find selectors.inner
    @inner.addClass @classNames

  open: ->
    @render()

    @overlay.add(@inner).css opacity: 0
    @el.appendTo @wrap
    @inner.css
      x: ( @wrap.width() - @inner.outerWidth() ) / 2
      y: ( @wrap.height() - @inner.outerHeight() ) / 2
      scale: .5

    @overlay.transition opacity: 1, transitionTime / 2
    @inner.transition scale: 1, opacity: 1, transitionTime, =>
      @bind()
      @onOpen @ if @onOpen?

  bind: ->

  close: (callback) ->
    @overlay.transition opacity: 0, transitionTime / 2
    @inner.transition scale: .5, opacity: 0, transitionTime, =>
      @el.remove()
      @onClose @ if @onClose?

module.exports = BaseModal
