
renderer = require '../../core/renderer'

Body = require './Body'
gameConfig = require '../config'

###
## Wall class

A physical Body (Game item) which shape gets rendered on screen in an SVG path element of a fixed
color

Read Walls for more about the way a Wall is added to the scene and handled Walls support all
shape types (`type`) that Body supports

Read Body for more
###

class Wall extends Body
  itemType: 'wall'

  constructor: (options, @world, @wrap, @color = gameConfig.wallsColor) ->
    # All Walls bodies bahave as static Box2D bodies
    options.interaction = 'static'

    super

    @render()

  render: ->
    # Prepare the context (Yep, even SVG is rendered using templates)
    ctx =
      x: @viewport.worldToScreen @x   # Screen X position
      y: @viewport.worldToScreen @y   # Screen Y position
      fill: @color

    # Set rectangle-specific rendering variables
    if @type is 'rect'
      ctx.width = @viewport.worldToScreen @width
      ctx.height = @viewport.worldToScreen @height
      ctx.x -= ctx.width / 2
      ctx.y -= ctx.height / 2

    # Set circle-specific rendering variables
    else if @type is 'circle'
      ctx.radius = @viewport.worldToScreen @radius

    # Set polygon-specific rendering variables
    else if @type is 'poly'
      ctx.points = []
      for point in @points
        x = (@viewport.worldToScreen point[0]) + ctx.x
        y = (@viewport.worldToScreen point[1]) + ctx.y
        ctx.points.push "#{x},#{y}"
      ctx.points = ctx.points.join ' '

    # Render SVG path element
    @el = $ renderer.render "svg-#{@type}", ctx
    # Append to Walls wrap
    @el.appendTo @wrap

module.exports = Wall
