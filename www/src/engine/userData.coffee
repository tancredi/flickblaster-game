
gameData = require './gameData'

levels = []

if localStorage.levelsProgress?
  levelsProgress = JSON.parse localStorage.levelsProgress
else
  levelsProgress = []

normaliseLevelsProgress = ->
  for level, i in levels
    if not levelsProgress[i]?
      levelsProgress[i] =
        locked: if i is 0 then false else true
        completed: false
        stars: 0

getLevelIndexByName = (name) ->
  for level, i in levels
    return i if level.name is name
  return null

module.exports =

  getLevelsProgress: ->
    levels = levels = gameData.get 'levels'
    normaliseLevelsProgress() if levelsProgress.length < levels.length
    return levelsProgress

  saveLevelScore: (levelName, stars) ->
    levelIndex = getLevelIndexByName levelName
    if levelIndex?
      levelsProgress[levelIndex].completed = true

      if stars > levelsProgress[levelIndex].stars
        levelsProgress[levelIndex].stars = stars

      # Unlock next level
      if levelsProgress[levelIndex + 1]?
        levelsProgress[levelIndex + 1].locked = false

      @storeLevelsProgress()

  storeLevelsProgress: ->
    localStorage.levelsProgress = JSON.stringify levelsProgress
