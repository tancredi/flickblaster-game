
renderer = require '../../core/renderer'

# Define lasers palette
# Add a `color` attribute using one of the following keys as value to an entity of 'laser' type
# to change its color
colors =
  yellow: '#f2c456'
  red: '#f56949'
  blue: '#5adef6'

lasers = []

###
## Lasers class

Similar to Layer class, but handling lasers in the scene
Renders the laser body using SVG, takes care of manipulating and updating it when needed
###

class Lasers

  constructor: (@world, @layer) ->
    @viewport = @world.viewport
    @width = @viewport.width
    @height = @viewport.height
    @render()

  # Renders SVG wrapper and inner element
  render: ->
    ctx =
      width: @viewport.worldToScreen @width
      height: @viewport.worldToScreen @height
    @el = $ renderer.render 'game-lasers', ctx

  # Add a laser with the given options
  add: (entityOptions) ->
    out = []

    # Renders a rectangle for each given set of body options
    for body in entityOptions.bodies
      width = @viewport.worldToScreen body.width
      height = @viewport.worldToScreen body.height
      x = @viewport.worldToScreen body.x + entityOptions.x
      y = @viewport.worldToScreen body.y + entityOptions.y

      ctx =
        x: x - width / 2
        y: y - height / 2
        width: width
        height: height
        fill: colors[entityOptions.attributes.color]

      # Create element and add it to the wrapper
      el = $ renderer.render 'svg-rect', ctx
      @el.append el
      out.push el

    return out

  # Hack to update the rendered SVG
  refresh: ->
    @layer.element.html ' '
    @el.clone().appendTo @layer.element
    @layer.element.html @layer.element.html()

module.exports = Lasers