fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

task 'watch', 'Watching for changes...', ->

    coffee = spawn 'coffee', [ '-cw', '-o', 'www/lib/', 'www/src/' ]
    coffee.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    coffee.stdout.on 'data', (data) ->
        print data.toString()
        bundle = spawn 'browserify', [ 'www/lib/app.js', '-o', 'www/js/app.js' ]
        bundle.stderr.on 'data', (data) ->
            process.stderr.write data.toString()
        bundle.stdout.on 'data', (data) ->
            print data.toString()

    style = spawn 'grunt', [ 'watch:less' ]
    style.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    style.stdout.on 'data', (data) ->
        print data.toString()

    handlebars = spawn 'grunt', [ 'watch:handlebars' ]
    handlebars.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
    handlebars.stdout.on 'data', (data) ->
        print data.toString()