module.exports = (grunt) =>
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-browserify2'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-parallel'

  grunt.initConfig

    less:
      development:
        options: compress: true, optimization: 2, yuicompress: true
        files:
          "./www/css/index.css": "./www/less/index.less"

    coffee:
      development:
        options: bare: true
        files: [
          expand: true
          cwd: 'www/src/',
          src: [ "**/*.coffee" ]
          dest: "./www/lib/"
          ext: '.js'
        ]

    browserify2:
      compile:
        entry: './www/lib/app.js'
        compile: './www/js/app.js'

    handlebars:
      compile:
        options:
          namespace: "window.templates"
          processName: (filename) ->
            parts = filename.split '.'
            parts.pop()
            templateName = parts.join '.'
            return templateName.substr './www/templates/'.length
          processPartialName: @processName
          partialRegex: /.*/
          partialsPathRegex: /\/partials\//
          partialsUseNamespace: true
        files:
          "./www/js/templates.js": [ "./www/templates/*/**.hbs" ]

    watch:

      less:
        files: [ './www/less/*/**.less', './www/less/*.less' ]
        tasks: 'less'
        options: interrupt: true

      coffee:
        files: './www/src/**/*.coffee'
        tasks: 'coffee'
        options: interrupt: true

      bundle:
        files: [ './www/src/**/*.coffee' ]
        tasks: [ 'coffee', 'browserify2' ]
        options: interrupt: true

      handlebars:
        files: [ "./www/templates/**/*.hbs" ]
        tasks: [ 'handlebars' ]
        options: interrupt: true

    parallel:
      watch:
        tasks: [
          {
            grunt: true,
            args: [ 'watch:less' ]
          }
          {
            grunt: true,
            args: [ 'watch:coffee' ]
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

  grunt.registerTask 'default', 'parallel:watch'
  grunt.registerTask 'build', [ 'less', 'coffee', 'browserify2', 'handlebars' ]
