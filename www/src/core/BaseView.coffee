
###
Base View class

Base class to extend from to create any view
Takes care of basic rendering and defines mein methods
###

renderer = require './renderer'
device = require './device'

# called by views module when initialising new views or changing state
class BaseView
  templateName: ''  # Relative to www/templates/views
  fixHeight: false  # Set view height to device screen height after rendering
  classNames: ''    # Will be applied along with '.view'
  context: {}       # Context used for rendering template

  # Render template, append element to given wrapper and perform additional operations
  render: (wrapper) ->
    rendered = renderer.render "views/#{@templateName}", @context

    @elements = main: $ "<div data-role='view' class='view #{@classNames}'>#{rendered}</div>"

    if @fixHeight then @elements.main.css height: device.getSize().height, overflow: 'auto'

    @getElements()

    if wrapper? then @elements.main.appendTo wrapper
    @resize()
    @bind()

    $(window).on 'resize', => @resize()
    
    return @

  # Method called when all transitions have been completed
  transitionComplete: ->

  # Method called after rendering
  getElements: ->

  # Method called after elements parsed
  bind: ->

  # Method called on window resize (and after rendering)
  resize: ->

  # Method called when view is closed
  close: -> @elements.main.remove()

  # Method called when view is hidden
  hide: ->  @elements.main.hide()

  # Method called when view is shown
  show: ->
    @elements.main.removeAttr 'style'
    @resize()
    @elements.main.show()

module.exports = BaseView
