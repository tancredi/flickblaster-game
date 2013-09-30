
renderer = require './renderer'
device = require './device'

getByRole = (require '../helpers/dom').getByRole

SettingsModal = require '../ui/modals/SettingsModal'

# Cache jQuery-wrapped window
win = $ window

templatesRoot = 'views/'

###
## Base View class

Base class to extend from to create any view
Takes care of basic rendering and defines main methods
###

class BaseView
  templateName: ''  # Relative to www/templates/views
  fixHeight: false  # Set view height to device screen height after rendering
  classNames: ''    # Will be applied along with '.view'
  context: {}       # Context used for rendering template

  # Render template, append element to given wrapper and perform additional operations
  render: (wrapper) ->
    rendered = renderer.render "#{templatesRoot}#{@templateName}", @context

    @elements = main: $ "<div data-role='view' class='view #{@classNames}'>#{rendered}</div>"

    if @fixHeight then @elements.main.css overflow: 'auto'

    @getElements()

    if wrapper? then @elements.main.appendTo wrapper
    @resize()
    @bind()

    win.on 'resize', => @resize()
    
    return @

  # Method called when all transitions have been completed
  transitionComplete: ->

  # Method called after rendering
  getElements: ->
    @elements.settings = getByRole 'settings', @elements.main

  # Method called after elements parsed
  bind: ->
    @resizeCallback = => @resize()
    win.on 'resize', @resizeCallback

    # Bind settings button
    @elements.settings.on device.getEvent('mousedown'), (e) ->
      e.preventDefault()
      new SettingsModal

  # Method called after elements are parsed and when window is resized
  resize: -> if @fixHeight then @elements.main.css height: device.getSize().height

  # Method called before closing transition
  unbind: ->

  # Method called when view is closed
  close: ->
    @elements.main.remove()
    win.off 'resize', @resizeCallback

  # Method called when view is hidden
  hide: ->  @elements.main.hide()

  # Method called when view is shown
  show: ->
    @elements.main.removeAttr 'style'
    @resize()
    @elements.main.show()

module.exports = BaseView
