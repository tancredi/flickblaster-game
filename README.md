
# FlickBlaster

An open-source HTML5 game created as a demo for my LXJS 2013 talk about game development

The game is written in [CoffeeScript](http://coffeescript.org/), bundled with [Browserify](http://browserify.org/) and wrapped as a [Cordova](http://cordova.apache.org/) cross-platform app, but can also be executed and tested in the browser.

The source code is commented end to end and for better understanding.


# Requirements

Includes requirements to build the app locally and run with a the local server for browser testing and also to deploy to a cordova build

* [Node.js](http://nodejs.org/) - Used for building the app, managing dependencies and run the local server for testing
```
brew install node
```

* [Cordova command-line interface](http://cordova.apache.org/docs/en/3.0.0/guide_cli_index.md.html) - Used to build and deploy the app to cordova with a few simple commands
```
sudo npm install -g cordova`
```

* [Coffeescript](coffeescript.com) - Server, build tools and the game source are written in coffeescript
```
sudo npm install -g coffee-script
```

* [Grunt](http://gruntjs.com/) - Runs build tasks
```
sudo npm install -g grunt-cli
```

# Install

```
git clone git@github.com:tancredi/flickblaster-game.git
cd flickblaster-game
npm install -d
```

# Compile

A Gruntfile and a Cakefile are setup for building the app.
Grunt can run all necessary tasks on his own, the Cakefile is only setup to execute some of the Grunt tasks and spawn a more performant coffee and browserify process along with those - Use Cake for faster development

### Using Grunt

* `grunt build` - Build the app once
* `grunt` - Watch for changes

### Using Cake

* `cake build` - Built the app once
* `cake watch` - Watch for changes

### Build Tasks

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

Run `cordova build` to build the app to all configured platforms.

You can also run `cordova build [platform]` to build to a specific platform. `ios` and `android` are already configured in the project.

Find the generated builds in the `platforms/` directory.

For more information about the Cordova Commmand-line interface read the [official documentation](http://cordova.apache.org/docs/en/2.9.0/guide_cli_index.md.html).

# Directory stucture

A map of the core directories of the app

```
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

