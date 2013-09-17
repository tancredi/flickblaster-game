
###
Button Behaviour class

Buttons are an Actionable Behaviour that executes an action specified with an 'action' attribute
on the Entity

Read BaseActionableBehaviour and the Actions module for more
###

BaseActionableBehaviour = require './BaseActionableBehaviour'

class ButtonBehaviour extends BaseActionableBehaviour

  constructor: (@entity, @world) ->
    super

    # The anchor value can be set to 'top', 'right', 'bottom' or 'left'
    @anchor = @entity.attributes.anchor or 'left'

  activate: (player) ->
    return if @active

    super

    # Get the button sprite
    sprite = @entity.sprites[0]

    # Parse its background position
    bgPos = (sprite.el.css 'background-position').split ' '
    bgPos =
      x: (bgPos[0].replace 'px', '') + 0
      y: (bgPos[1].replace 'px', '') + 0

    # Run the pressing effect by moving the background
    # The direction is determined by the anchor property

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

    # Animate the background moving
    sprite.el.transition css, 100
    @active = true

  update: ->

module.exports = ButtonBehaviour
