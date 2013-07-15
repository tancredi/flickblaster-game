
# Import Core Modules
device = require './core/device'
renderer = require './core/renderer'
views = require './core/views'
gameData = require './engine/gameData'

# Import Secondary Modules
touchables = require './ui/touchables'

# Import Views
views.load
  levels: require './views/LevelsView'
  game: require './views/GameView'

# Initialise views
views.init()

# Load templates
renderer.templates = window.templates

# Initialise app
init = -> if device.isTouch() then bind() else onDeviceReady()

# Bind deviceReady event
bind = -> document.addEventListener 'deviceready', onDeviceReady, false

onDeviceReady = ->

# Initialise clickables
touchables.initialise()

# Create app object
gameData.init()
gameData.onReady ->
	views.open 'game', null, null, false, '02'
	# views.open 'levels'

init()