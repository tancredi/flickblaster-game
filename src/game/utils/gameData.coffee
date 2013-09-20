
###
## Game Data module

Handles the loading and storing of the JSON game assets

The assets used are located in www/game/ and they are:
1. `levels.json`: *Index of all levels*
2. `levels/[level-name].json`: *Level maps*
3. `materials.json`: *Contains all materials properties*
4. `sprites.json`: *All sprite presets*
5. `presets.json`: *All entity presets*
###

gameConfig = require '../config'

baseDir = gameConfig.gameDataPath

# Loaded data
gameData =
  sprites: {}
  materials: {}
  levels: []

ready = false         # Data loaded stated
readyCallbacks = []   # Callbacks to execute when data is loaded

module.exports =

  init: ->
    @loadData [ 'sprites', 'materials', 'presets', 'levels', 'tutorials' ], ->
      ready = true
      cb() for cb in readyCallbacks

  # Given a data type and ID returns an object
  # E.g. 'levels', '01'
  get: (type, id) ->
    throw "GameData error: No data for '#{type}'" if not _.has gameData, type
    return gameData[type] if not id?
    throw "GameData error: '#{type}' does not contain '#{id}'" if not _.has gameData[type], id
    return gameData[type][id]

  # Attach a callback to execute when .ready
  onReady: (cb) ->
    if ready then cb()
    else readyCallbacks.push cb

  # Levels are treated differently from other types of assets, and are loaded individually
  # on request
  loadLevel: (id, callback) ->
    $.getJSON "#{baseDir}/levels/#{id}.json", (level) ->
      callback level if typeof callback is 'function'
    .fail (req, err) -> throw "Error loading level: #{id}.json - #{err}"

  # Load data from an asset
  loadData: (nsArr, callback) ->
    loaded = 0
    for ns in nsArr
      do (ns) =>
        $.getJSON "#{baseDir}/#{ns}.json", (data) =>
          gameData[ns] = data
          @solveInheritances ns
          loaded++
          callback data if loaded is nsArr.length and typeof callback is 'function'
        .fail (req, err) -> throw "Error loading game data: #{ns}.json - #{err}"

  # Solve inheritance specified between all asset's objects
  solveInheritances: (ns) ->
    for itemId, item of gameData[ns]
      item = @solveInheritance ns, itemId

  # Solve inheritance of given object
  solveInheritance: (ns, id) ->
    while gameData[ns][id].extends?
      extendFrom = gameData[ns][id].extends
      gameData[ns][id].extends = null
      gameData[ns][id] = $.extend {}, (@get ns, extendFrom), gameData[ns][id]
    return gameData[ns][id]
