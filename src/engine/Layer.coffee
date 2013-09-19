
Entity = require './Entity'
renderer =  require '../core/renderer'
device = require '../core/device'

###
## Layer class

A layer contains and handles groups of Entities
It also provides the items a separate DOM element to render within, so than the order of display of
all items is manageable

It also takes care of their updating
###

class Layer

  constructor: (@world, @itemsType, @id) ->
    @viewport = @world.viewport
    @element = $ renderer.render 'game-layer'
    @element.appendTo @viewport.el
    @items = []

  # Creates and adds an Entity with the given options
  add: (options) =>
    # So far layers only support entities. Other types of item types
    if @itemsType is 'entity'
      item = new Entity options, @
    else return

    @items.push item
    return item

  # Update all children
  update: =>
    for item in @items
      item.update() if not item.removed

module.exports = Layer
