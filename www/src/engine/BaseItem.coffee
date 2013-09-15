
# Base Item class
#
# Item classes that interact with the game logic have to extend from here
#
# E.g. Entities, Bodies, Sprites and Walls extend from BaseItem
#
# The World and Layer classes will need to always have acces to the basic
# method specified in this class

# Default properties
defaults = x: 0, y: 0

class BaseItem
  itemType: 'base' # Must change when extending

  constructor: (options, @layer) ->
    options = $.extend true, {}, defaults, options
    @x = options.x or 0
    @y = options.y or 0
    @removed = false

  translate: (x, y) ->
    # Adds given x and y to current item position
    @moveTo @x + x, @y + y

  moveTo: (x, y) ->
    # Absolutely sets the physical position of the item to given x and y
    @x = x
    @y = y

  update: -> # Called in any gameloop iteration

  remove: -> # Called whenever item needs removing

module.exports = BaseItem
