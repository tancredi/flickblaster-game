
Body = require './Body'
renderer = require '../core/renderer'

wallsColor = '#a2bfc9'

class Wall extends Body
  itemType: 'wall'

  constructor: (options, @world, @wrap, @color = wallsColor) ->
    options.interaction = 'static'
    super
    @render()

  render: ->
    ctx =
      x: @viewport.worldToScreen @x
      y: @viewport.worldToScreen @y
      fill: @color

    if @type is 'rect'
      ctx.width = @viewport.worldToScreen @width
      ctx.height = @viewport.worldToScreen @height
      ctx.x -= ctx.width / 2
      ctx.y -= ctx.height / 2

    if @type is 'circle'
      ctx.radius = @viewport.worldToScreen @radius

    else if @type is 'poly'
      ctx.points = []
      for point in @points
        x = (@viewport.worldToScreen point[0]) + ctx.x
        y = (@viewport.worldToScreen point[1]) + ctx.y
        ctx.points.push "#{x},#{y}"
      ctx.points = ctx.points.join ' '

    @el = $ renderer.render "svg-#{@type}", ctx
    @el.appendTo @wrap

module.exports = Wall