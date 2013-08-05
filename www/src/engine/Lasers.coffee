
renderer = require '../core/renderer'

colors =
  yellow: '#f2c456'

lasers = []

class Lasers

  constructor: (@world, @layer) ->
    @viewport = @world.viewport
    @width = @viewport.width
    @height = @viewport.height
    @render()

  render: ->
    ctx =
      width: @viewport.worldToScreen @width
      height: @viewport.worldToScreen @height
    @el = $ renderer.render 'game-lasers', ctx

  add: (entityOptions) ->
    out = []

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

      el = $ renderer.render 'svg-rect', ctx
      @el.append el
      out.push el

    return out

  refresh: ->
    @layer.element.html ' '
    @el.clone().appendTo @layer.element
    @layer.element.html @layer.element.html()

module.exports = Lasers