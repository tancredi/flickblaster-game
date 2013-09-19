
Wall = require './Wall'
Body = require './Body'
renderer = require '../core/renderer'

# Default wall thickness (Used for the 4 main walls)
thickness = 10

###
## Walls Class

Used as a child of World, handles the creation of the 4 Walls around the viewport and any other
level-specific Wall passed from the World after loading the level data

Also takes care of wrapping its children into an SVG object and refreshing its tree to display the
updated render after the addition or change of any child Wall
###

class Walls

  constructor: (@world) ->
    @width = @world.viewport.width    # Shortcut to Viewport width
    @height = @world.viewport.height  # Shortcut to Viewport height
    @walls = []

    @render()
    @build()
    @refresh()

  # Render the SVG element wrapping paths for all children Walls
  render: ->
    ctx =
      width: @world.viewport.worldToScreen @width   # Width on screen
      height: @world.viewport.worldToScreen @height # Height on screen

    # Create wrap element
    @wrap = $ renderer.render 'game-walls', ctx
    # Get its inner SVG
    @svg = @wrap.find 'svg'
    # Add it to the scene
    @wrap.appendTo @world.stage

  refresh: ->
    # Rebuild the wrap DOM tree to refresh
    @wrap.html @wrap.html()
    # Get the SVG after it's been re-rendered
    @svg = @wrap.find 'svg'

  # Instanciate and add a Wall with the given options
  add: (options) -> @walls.push new Wall options, @world, @svg

  # Create the 4 walls around the Viewport
  build: ->
    for dir in [ 'x', 'y' ]
      for opposite in [ false, true ]
        if dir is 'x'
          w = @width
          h = thickness
          x = @width / 2
          y = if opposite then @height - thickness / 2 else thickness / 2
        else
          w = thickness
          h = @height
          x = if opposite then @width - thickness / 2 else thickness / 2
          y = @height / 2
        @add type: 'rect', x: x, y: y, width: w, height: h

module.exports = Walls
