
###
## User Data module

Loads or creates user progress data, takes care of its storage and loading in the
`window.localStorage` object, interacts with the gameData module to get levels data and normalise
user progress
###

gameData = require './gameData'

# Will contain the level objects loaded from gameData
levels = []

# Load level progress data from localStorage or create if missing
if localStorage.levelsProgress?
  levelsProgress = JSON.parse localStorage.levelsProgress
else
  levelsProgress = []

# Normalises progress in base on the actual amount of levels
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

  # Returns all levels progress - runs normalisation if needed
  getLevelsProgress: ->
    levels = levels = gameData.get 'levels'
    normaliseLevelsProgress() if levelsProgress.length < levels.length
    return levelsProgress

  saveLevelScore: (levelName, stars) ->
    levelIndex = getLevelIndexByName levelName

    if levelIndex?
      levelsProgress[levelIndex].completed = true

      # Save the stars scoring only if higher than the current one
      # So it can be called freely without user losing progress
      if stars > levelsProgress[levelIndex].stars
        levelsProgress[levelIndex].stars = stars

      # Unlock next level if exists
      if levelsProgress[levelIndex + 1]?
        levelsProgress[levelIndex + 1].locked = false

      @storeLevelsProgress()

  # Saves all levels progress in localStorage
  storeLevelsProgress: ->
    localStorage.levelsProgress = JSON.stringify levelsProgress
