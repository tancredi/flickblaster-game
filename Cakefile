
###
Cakefile

Mixes the use of grunt tasks for building the app with the direct spawning of coffeescript and
browserify commands

Much faster watching and compiling with coffeescript and browserify directly than using Grunt tasks
Run 'cake build' to build the app and 'cake watch' to develop

Read Gruntfile for more
###

fs = require 'fs'

{print} = require 'util'
{spawn} = require 'child_process'

# Execute a command from just a string, fire callback if successful
exec = (command, callback = null) ->
    parts = command.split ' '
    process = spawn parts[0], parts.slice 1

    # Log errors if any
    process.stderr.on 'data', (data) ->
        process.stderr.write data.toString()

    # Log output if any
    process.stdout.on 'data', (data) ->
        print data.toString()
        callback(data) if callback?

# Build task
task 'build', 'Watching for changes...', ->
    # Execute build grunt task
    exec 'grunt build'

# Watch task
task 'watch', 'Watching for changes...', ->
    # Compile CoffeeScript
    exec 'coffee -cw -o ./lib ./src', ->
        # Bundles app.js with the generated files using local browserify
        # Uses local version to avoid forcing the global installation of an extra dependency
        localBrowserify = 'node_modules/browserify/bin/cmd.js'
        exec "node #{localBrowserify} lib/app.js -o www/js/app.js"

    # Execute watch LESS grunt task
    exec 'grunt watch:less'

    # Execute watch Handlebars grunt task
    exec 'grunt watch:handlebars'
