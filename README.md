
# FlickBlaster

An HTML5 top-down physics-based puzzle game layed out in MVC fashion, rendered using a combination of DOM, SVG and canvas.

The game is written in [CoffeeScript](http://coffeescript.org/), bundled with [Browserify](http://browserify.org/) and wrapped as a [Cordova](http://cordova.apache.org/) cross-platform app, but can also be executed and tested in the browser.

Also, the styles compile from [LESS CSS](http://lesscss.org/) and UI components are rendered using pre-compiled [Handlebars](http://handlebarsjs.com/) templates.

# Quick source overlook

The coffeescript source of the app is all contained in `src/`
The directory structure is layed out as follow:

* core - *The web-app framework core (Template rendering, routing, UI, ...) is contained in*
* views - *All view controllers. GameView contains part of the base game mechanics*
* engine - *The game engine core (World, Viewport, Entity, ...) is contained in this directory.*
* behaviours - *The bahaviours of all game entities that determine the game logic*
* ui - *UI elements and modules*
* helpers - *Shared utilities*

# Global dependencies

Includes requirements to build the app locally and run with a the local server for browser testing and also to deploy to a cordova build

* [Node.js](http://nodejs.org/) Install: `brew install node`
* [Coffeescript](coffeescript.com) - To build the web source and run the server - `sudo npm install -g coffee-script`
* [Cordova command-line interface](http://cordova.apache.org/docs/en/3.0.0/guide_cli_index.md.html) - To build mobile source - `sudo npm install -g cordova`

# Install

```
git clone git@github.com:tancredi/flickblaster-game.git
cd flickblaster-game
npm install -d
```

Now you just have to compile the app and run the server

# Compile

Build the app using [Cake](http://coffeescript.org/documentation/docs/cake.html)

* `cake build` - Built the app once
* `cake watch` - Watch for changes
* `cake docs` - Update documentation
* `cake downsize` - Generate resized assets for different pixel-ratios

### Building Tasks

* less - *Compile `less/index.less` into `www/css/index.css`*
* handlebars - *Pre-compile Handlebars templates in `templates/` into `www/js/templates.js`*
* coffee - *Compile the CoffeeScript source in `src/` in Javascript inside `lib/`*
* bundle - *Wrap the generated JavaScript in `lib/` using Browserify into a single `www/js/app.js`*

# Run

To start the server, run

```
npm start
```

You can open your browser at http://localhost:3000 and start playing

# Build with Cordova

First, you may have to setup your environment to build for ios / android.
For instructions on how to do that read the Apache Cordova Documentation:

* [Getting Started with iOS](http://cordova.apache.org/docs/en/2.5.0/guide_getting-started_ios_index.md.html)
* [Getting Started with Android](http://cordova.apache.org/docs/en/2.5.0/guide_getting-started_android_index.md.html)

Run `cordova build` to build the app to all configured platforms.

You can also run `cordova build [platform]` to build to a specific platform. `ios` and `android` are already configured in the project.

Find the generated builds in the `platforms/` directory.

For more information about the Cordova Commmand-line interface read the [official documentation](http://cordova.apache.org/docs/en/2.9.0/guide_cli_index.md.html).

# Directory stucture

A map of the core directories of the app

```
├── docs - Contains Codo documentation
├── less - Contains the LESS source
├── platforms
│   ├── android - Android app
│   └── ios - iOS Xcode project
├── plugins - Cordova plugins
├── src - App source
├── templates - Handlebards templates
└── www - Web-app root
    ├── css - Compiled CSS
    ├── game - JSON Game data
    └── js - Compiled and vendor JavaScript
```
# Documentation

The documentation contained in `docs/` is generated using [Codo](https://github.com/netzpirat/codo).

Generate an updated version by running `cake docs`.

# Dependencies

* `express`: [Express 3](http://expressjs.com/) - Used to run the server
* `coffee-script`: [Coffeescript](http://coffeescript.org) - Used to compile and run the game
* `browserify`: [Browserify](http://browserify.org/) - Used to bundle javascript modules for the browser
* `watch-tree-maintained`: [Watch-Tree](https://github.com/tafa/node-watch-tree) - Used to set up watch tasks
* `async`: [Async.js](https://github.com/caolan/async) - Used to ease asynchronus operations
* `cli-color`: [Cli-color](https://github.com/medikoo/cli-color) - Used to easily display colors in the console
* `less`: [LESS CSS](http://lesscss.org/ - Used to pre-process the CSS
* `handlebars`: [Handlebars](http://handlebarsjs.com/) - Used to pre-compile templates
* `codo`: [Codo](https://github.com/netzpirat/codo) - Used to generate the documentation
* `retina-downsizer`: [Retina Downsizer](https://github.com/tancredi/node-retina-downsizer) - Used to generate resized assets for different pixel-ratios
