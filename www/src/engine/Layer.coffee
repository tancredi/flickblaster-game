
Entity = require './Entity'
renderer =  require '../core/renderer'
device = require '../core/device'

class Layer

  constructor: (@world, @itemsType, @id) ->
    @viewport = @world.viewport
    @element = $ renderer.render 'game-layer'
    @element.appendTo @viewport.el
    @idIncr = 0
    @items = []
    @groups = {}

  add: (options) =>
    if @itemsType is 'entity'
      item = new Entity options, @
    else return

    @items.push item
    return item

  update: =>
    for item in @items
      item.update() if not item.removed

module.exports = Layer
