
###
## App File

The main file that starts up the app

* Initialises the app and every module used in it
* Defines views routing
* Loads the Handlebars templates in the Renderer
* If the app is loaded through phonegap listens for `deviceready` Phonegap event
* Instanciates and open the first view
###

# Import Core Modules
device = require './core/device'
renderer = require './core/renderer'
views = require './core/views'
gameData = require './game/utils/gameData'
sounds = require './game/utils/sounds'

# Import Secondary Modules
touchables = require './ui/touchables'

# Init sounds
sounds.init()

# Import Views
views.load
  home: require './views/HomeView'
  levels: require './views/LevelsView'
  achievements: require './views/AchievementsView'
  game: require './views/GameView'

# Initialise views
views.init()

# Load templates
renderer.templates = window.templates

# Initialise app
init = -> if device.isTouch() then bind() else onDeviceReady()

# Bind deviceReady event
bind = -> document.addEventListener 'deviceready', onDeviceReady, false

onDeviceReady = -> # nothing here

# Initialise clickables
touchables.initialise()

# Create app object
gameData.init()
gameData.onReady ->
  # Open Levels view
  views.open 'home'
  views.open 'game', null, null, false, '28'

init()
