###
Gruntfile

Automates the build of the app, takes care of watching and compiling coffeescript - bundling it
using browserify, LESS, and Handlebars templates

Since the most popular grunt modules for compiling CoffeeScript were slower than directly using
CoffeeScript command line tool it uses the 'grunt-exec' module to spawn a 'coffee' process instead

Run 'grunt build' to build the app, 'grunt' to watch for changes

Although the watching is still slower for coffeescript and browserify, so to develop faster use
Cake tasks - Read Cakefile for more
###

module.exports = (grunt) =>
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-browserify2'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-parallel'

  grunt.initConfig

    # Compile LESS into CSS
    less:
      development:
        options: compress: true, optimization: 2, yuicompress: true
        files:
          "www/css/index.css": "less/index.less"

    # Compile CoffeeScript
    exec:
      coffee:
        cmd: -> "coffee -o lib/ src/"

    # Bundle generated JavaScript using Browserify
    browserify2:
      compile:
        entry: './lib/app.js'
        compile: 'www/js/app.js'

    # Pre-compile Handlebars templates in js/templates.js
    handlebars:
      compile:
        options:
          namespace: "window.templates"
          processName: (filename) ->
            parts = filename.split '.'
            parts.pop()
            templateName = parts.join '.'
            return templateName.substr 'templates/'.length
          processPartialName: @processName
          partialRegex: /.*/
          partialsPathRegex: /\/partials\//
          partialsUseNamespace: true
        files:
          "www/js/templates.js": [ "templates/*/**.hbs" ]

    # All watch tasks
    watch:

      # Watch the LESS directory for changes
      less:
        files: [ 'www/less/*/**.less', 'www/less/*.less' ]
        tasks: 'less'
        options: interrupt: true, spawn: false, interval: 0

      # Watch CoffeeScript changes, compile and bundle with Browserify
      bundle:
        files: [ 'src/**/*.coffee' ]
        tasks: [ 'exec:coffee', 'browserify2' ]
        options: interrupt: true, spawn: false, interval: 0

      # Watch the templates directory for changes
      handlebars:
        files: [ "templates/**/*.hbs" ]
        tasks: [ 'handlebars' ]
        options: interrupt: true, spawn: false, interval: 0

    # Run all watch tasks in parallel
    parallel:
      watch:
        tasks: [
          {
            grunt: true,
            args: [ 'watch:less' ]
          }
          {
            grunt: true,
            args: [ 'watch:bundle' ]
          }
          {
            grunt: true,
            args: [ 'watch:handlebars' ]
          }
        ]

  # Register default task to watch and build task
  grunt.registerTask 'default', 'parallel:watch'
  grunt.registerTask 'build', [ 'less', 'exec:coffee', 'browserify2', 'handlebars' ]
