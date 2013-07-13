
# Templates manager and renderer using Handlebars

module.exports =

  templates: {}

  # Compiles string in template or just returns if already compiled
  compile: (tpl) -> if typeof template is 'function' then return tpl else return Handlebars.compile tpl

  # Stores template with an id
  set: (id, template) -> @templates[id] = if typeof template is 'string' then @compile template else template

  # Gets template by id
  get: (nsString = null) -> if nsString? then @templates[nsString] else @templates

  # Render template by id
  render: (id, data) -> if @get(id)? then @get(id) data else throw "Template '#{id}' not found"