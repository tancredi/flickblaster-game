
module.exports =

  stopAndPop: (entity) ->
    for sprite in entity.sprites
      sprite.el.transition scale: .1, opacity: 0, 600, =>
