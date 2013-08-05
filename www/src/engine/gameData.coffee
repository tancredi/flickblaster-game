
baseDir = 'game/'

gameData =
  sprites: {}
  materials: {}
  levels: []

ready = false
readyCallbacks = []

module.exports =
  init: ->
    @loadData [ 'sprites', 'materials', 'presets', 'levels' ], ->
      ready = true
      cb() for cb in readyCallbacks

  get: (type, id) ->
    throw "GameData error: No data for '#{type}'" if not _.has gameData, type
    return gameData[type] if not id?
    throw "GameData error: '#{type}' does not contain '#{id}'" if not _.has gameData[type], id
    return gameData[type][id]

  onReady: (cb) ->
    if ready then cb()
    else readyCallbacks.push cb

  loadLevel: (id, callback) ->
    $.getJSON "#{baseDir}levels/#{id}.json", (level) ->
      callback level if typeof callback is 'function'
    .fail (req, err) -> throw "Error loading level: #{id}.json - #{err}"

  loadData: (nsArr, callback) ->
    loaded = 0
    for ns in nsArr
      do (ns) =>
        $.getJSON "#{baseDir}#{ns}.json", (data) =>
          gameData[ns] = data
          @solveInheritances ns
          loaded++
          callback data if loaded is nsArr.length and typeof callback is 'function'
        .fail (req, err) -> throw "Error loading game data: #{ns}.json - #{err}"

  solveInheritances: (ns) ->
    for itemId, item of gameData[ns]
      item = @solveInheritance ns, itemId

  solveInheritance: (ns, id) ->
    while gameData[ns][id].extends?
      extendFrom = gameData[ns][id].extends
      gameData[ns][id].extends = null
      gameData[ns][id] = $.extend {}, (@get ns, extendFrom), gameData[ns][id]
    return gameData[ns][id]
