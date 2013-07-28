
Wall = require './Wall'
Body = require './Body'
renderer = require '../core/renderer'

thickness = 10

class Walls

  constructor: (@world) ->
    @width = @world.viewport.width
    @height = @world.viewport.height
    @render()
    @walls = []
    @build()
    @refresh()

  render: ->
    ctx =
      width: @world.viewport.worldToScreen @width
      height: @world.viewport.worldToScreen @height
    @wrap = $ renderer.render 'game-walls', ctx
    @svg = @wrap.find 'svg'
    @wrap.appendTo @world.stage

  refresh: ->
    @wrap.html @wrap.html()
    @svg = @wrap.find 'svg'

  add: (options) -> @walls.push new Wall options, @world, @svg

  build: ->
    walls = []
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
        walls.push type: 'rect', x: x, y: y, width: w, height: h
    @add wall for wall in walls

module.exports = Walls
