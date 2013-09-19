
###
## Renderer module

Handles the storing and rendering of templates

The templates stored are Handlebars templates pre-compiled into functions
They are set in the main App file

Used to render all UI elements
###

module.exports =

  templates: {}

  # Compiles string in template or just returns if already compiled
  compile: (tpl) -> if typeof template is 'function' then return tpl else return Handlebars.compile tpl

  # Stores template with an id
  set: (id, template) -> @templates[id] = if typeof template is 'string' then @compile template else template

  # Gets template by id
  get: (nsString = null) -> if nsString? then @templates[nsString] else @templates

  # Render template by id
  render: (id, data) ->
    if @get(id)?
      @get(id) data
    else if @get("partials/#{id}")?
      @get("partials/#{id}") data
    else
      throw Error "Template '#{id}' not found"
