
###
Base Item class

Item classes that interact with the game logic have to extend from here

E.g. Entities, Bodies, Sprites and Walls extend from BaseItem

The World and Layer classes will need to always have acces to the basic
method specified in this class
###

# Default properties
defaults = x: 0, y: 0

class BaseItem
  itemType: 'base' # Must change when extending

  constructor: (options, @layer) ->
    options = $.extend true, {}, defaults, options
    @x = options.x or 0
    @y = options.y or 0
    @removed = false

  # Add given x and y to current item position
  translate: (x, y) ->
    @moveTo @x + x, @y + y

  # Absolutely set the physical position of the item to given x and y
  moveTo: (x, y) ->
    @x = x
    @y = y

  # Called in any gameloop iteration
  update: ->

  # Called whenever item needs removing
  remove: ->

module.exports = BaseItem
