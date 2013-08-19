
BaseActionableBehaviour = require './BaseActionableBehaviour'

class ButtonBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    @anchor = @entity.attributes.anchor or 'left'

  activate: (player) ->
    return if @active
    super

    sprite = @entity.sprites[0]

    bgPos = (sprite.el.css 'background-position').split ' '
    bgPos =
      x: (bgPos[0].replace 'px', '') + 0
      y: (bgPos[1].replace 'px', '') + 0

    css = {}

    if @anchor is 'left' or @anchor is 'right'
      width = sprite.el.width()
      css.width = width / 2
      css.backgroundPosition = "#{bgPos.x - width / 2}px #{bgPos.y}px"
      if @anchor is 'right' then css.left = width / 2

    if @anchor is 'top' or @anchor is 'bottom'
      height = sprite.el.height()
      css.height = height / 2
      css.backgroundPosition = "#{bgPos.x}px -#{bgPos.y - height / 2}px"
      if @anchor is 'bottom' then css.top = height / 2

    sprite.el.transition css, 100
    @active = true

  update: ->

module.exports = ButtonBehaviour
