
defaults =
  x: 0
  y: 0

class BaseItem
  type: 'base'

  constructor: (options, @layer) ->
    options = $.extend true, {}, defaults, options
    @x = options.x or 0
    @y = options.y or 0
    @removed = false

  translate: (x, y) -> @moveTo @x + x, @y + y

  moveTo: (x, y) ->
    @x = x
    @y = y

  update: ->

  remove: ->

module.exports = BaseItem
