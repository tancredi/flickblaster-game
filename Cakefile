
###
## Cakefile

Tasks to build the app's JavaScript (From Coffeescript), bundle it with Browserify, compile LESS
and Handlebars templates

Also, it can update the documentation using Codo
###

fs = require 'fs'
path = require 'path'
watcher = (require 'watch-tree-maintained').watchTree
color = require 'cli-color'
async = require 'async'
RetinaDownsizer = require 'retina-downsizer'
Handlebars = require 'handlebars'
walk = require 'walkdir'

{print} = require 'util'
{spawn} = require 'child_process'

# Build configuration
confs =
  css:
    src: 'less'
    main: 'index.less'
    out: 'www/compiled.css'
    pagesDir: 'pages'
    match: /\.styl$/i
    setupDirs: [ 'public/css', 'public/css/pages' ]
  js:
    src: 'src'
    lib: 'lib'
    out: 'www/js'
    main: 'app.js'
  handlebars:
    src: 'templates'
    out: 'www/js/templates.js'
    namespace: 'window.templates'
    extension: 'hbs'
  manifest:
    src: 'www',
    out: 'www/cache.manifest'
    template: 'templates/cache.manifest.hbs'
    files: [
      'compiled.css'
    ]
    dirs: [
      'js', 'assets', 'fonts', 'game-data'
    ]
    ignorePatterns: [
      /\.(psd)$/i
    ]

# Watch configuration
watchRate = 3

downsize = new RetinaDownsizer targets: 'www/assets', densities: [ 1.5, 1 ]

# Execute a command from just a string, fire callback if successful
exec = (command, callback = null) ->
    parts = command.split ' '
    proc = spawn parts[0], parts.slice 1
    failed = false

    # Log errors if any
    proc.stderr.on 'data', (data) ->
        process.stderr.write data.toString()
        failed = true

    # Log output if any
    proc.stdout.on 'data', (data) ->
        process.stderr.write data.toString()

    proc.on 'close', ->
        callback() unless failed or not callback?

# Build functions that will be called by both 'build' and 'watch' tasks
build =

  js: (callback) ->
    # Compile CoffeeScript
    console.log color.yellow 'Compiling CoffeeScript...'

    exec "coffee -o #{confs.js.lib} #{confs.js.src}", ->

      # Bundles app.js with the generated files using local browserify
      # Uses local version to avoid forcing the global installation of an extra dependency

      console.log color.green('✔') + color.white("  CoffeeScript compiled in #{confs.js.lib}")

      src = "#{confs.js.lib}/#{confs.js.main}"
      out = "#{confs.js.out}/#{confs.js.main}"

      # Local browserify script - cut down global dependencies
      localBrowserify = 'node_modules/browserify/bin/cmd.js'

      exec "node #{localBrowserify} #{src} -o #{out}", ->
        console.log color.green('✔') + color.white("  Created #{out}\n")
        callback() if callback

  css: (callback) ->
    console.log color.magentaBright 'Compiling CSS...'

    src = "#{confs.css.src}/#{confs.css.main}"
    out = confs.css.out

    # Local LESS script - cut down global dependencies
    localLess = 'node_modules/less/bin/lessc'

    exec "node #{localLess} #{src} -o --yui-compress #{out}", ->
      console.log color.green('✔') + color.white("  Created #{confs.css.out}\n")
      callback() if callback

  handlebars: (callback) ->
    console.log color.blueBright 'Compiling Handlebars templates...'

    src = confs.handlebars.src
    out = confs.handlebars.out
    ns = confs.handlebars.namespace
    ext = confs.handlebars.extension

    localHandlebars = 'node_modules/handlebars/bin/handlebars'
    exec "node #{localHandlebars} -p --namespace=#{ns} --extension=#{ext} -wf #{out} #{src}", ->
      console.log color.green('✔') + color.white("  Created #{out}\n")
      callback() if callback

  # Synchronously generating manifest file
  manifest: (callback) ->
    console.log color.yellowBright 'Generating cache manifest...'

    cache = []

    for dir in confs.manifest.dirs
      files = walk.sync path.resolve confs.manifest.src, dir
      for file in files
        allowed = true
        for pattern in confs.manifest.ignorePatterns
          if (file.match pattern)?
            console.log 'fds'
            allowed = false
        if allowed
          cache.push path.join dir, file

    cache.concat confs.manifest.files

    template = fs.readFileSync confs.manifest.template, 'utf8'
    template = Handlebars.compile template

    out = template cache: cache

    fs.writeFileSync confs.manifest.out, out
    console.log color.green('✔') + color.white("  Generated manifest in #{confs.manifest.out}\n")

    callback() if callback

# Run all build tasks
buildAll = (callback) ->
  tasks = []

  console.log color.bold.cyan 'Building app...\n'

  # Adds all build tasks to an array
  for taskId of build
    tasks.push build[taskId]

  # Executes tasks in series
  async.series tasks, ->
    console.log color.bold.green "All done\n"
    callback() if callback

# Define 'build' task
task 'build', ->
  buildAll()

# Define 'watch' task
task 'watch', ->
  buildAll ->
    console.log color.bold.cyan 'Watching for changes...\n'

    taskNames = []

    # Initialise watchers for all configured sources
    for taskId, conf of confs
      taskNames.push taskId

      # Run build function every time a file of the given source changes
      do (taskId) ->
        (watcher conf.src, 'sample-rate': watchRate).on 'fileModified', (stat) ->
          console.log "#{color.cyan('Changed detected in')} #{color.white(stat)}\n"
          build[taskId]()

    # Creates string listing watch tasks
    if taskNames.length > 1
      lastTask = taskNames.pop()
      tasksStr = taskNames.join(', ') + " and #{lastTask}"
    else
      tasksStr = taskNames[0]

# Define 'docs' task
task 'docs', ->
  console.log color.yellowBright 'Generating documentation...'

  src = 'src'
  out = 'docs'

  # Local Doco script - cut down global dependencies
  localCodo = "node_modules/codo/bin/codo"

  # Generates updated documentation using Codo
  exec "#{localCodo} #{src} -o #{out}", ->
    console.log color.green('✔') + color.white("  Generated documentation in #{out}\n")

# Define 'downsize' task
task 'downsize', ->
  downsize.run()

# Define 'manifest' task
task 'manifest', ->
  build.manifest()
