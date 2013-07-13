
# Schemas manager, takes care of migrations and versioning of DB tables

db = require './db'
debugDb = require('./debug').debugDB

# Retrieves info on installed schemas on local storage 
if _.has localStorage, 'installedSchemas'
  installedSchemas = JSON.parse localStorage.installedSchemas or {}
else
  installedSchemas = {}

schemasReadyCallbacks = []

module.exports =

  schemas: {}
  loaded: 0
  ready: false

  # Schemas are loaded in a bulk in app main file
  load: (ns, schema) ->
    if typeof ns is 'object'
      routes = ns
      @load ns, schema for ns, schema of routes
    else @schemas[ns] = schema

  # Initialises all schemas
  initialise: ->
    if @getSchemasCount() is 0 then @onSchemasReady()
    else @initSchema schema for id, schema of @schemas

  # Create schema table if missing, updates (ereasing data) if not matching schema
  initSchema: (schema) ->
    @log "Init '#{schema.tableName}' schema..."
    tableName = schema.tableName
    isInstalled = _.has installedSchemas, tableName

    if isInstalled
      serialisedSchema = JSON.stringify schema.fields
      isUpdated = serialisedSchema is installedSchemas[tableName]

      if not isUpdated
        @migrateSchema schema, => @onSchemaReady schema
      else
        @onSchemaReady schema
    else
      @installSchema schema, => @onSchemaReady schema

  # Creates table for schema
  installSchema: (schema, callback) ->
    @log "Install '#{schema.tableName}' schema..."
    db.createTable schema.tableName, schema.fields, =>
      installedSchemas[schema.tableName] = JSON.stringify schema.fields
      @onSchemaReady schema

  # Migrates schema (Just replacing it really, at the mo')
  migrateSchema: (schema, callback) -> db.dropTable schema.tableName, => @installSchema schema, callback

  # Executes after each schema is created and gets back to main callback if all ready
  onSchemaReady: (schema) ->
    @log "'#{schema.tableName}' ready!"
    @ready++
    if @ready is @getSchemasCount()
      @ready = true
      @onSchemasReady()

  # Executed when all schemas are ready
  onSchemasReady: ->
    @log 'All schemas loaded!'
    localStorage.installedSchemas = JSON.stringify installedSchemas
    callback() for callback in schemasReadyCallbacks

  # Bind a callback to onSchemasReady
  onReady: (callback) ->
    if @ready then callback()
    schemasReadyCallbacks.push callback

  getSchemasCount: ->
    count = 0
    count++ for schema of @schemas
    return count

  # Logs schema operations only if debugDb is active
  log: (m) -> if debugDb then console.log "DB: #{m}"
