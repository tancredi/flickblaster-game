module.exports = {
  templates: {},
  compile: function(tpl) {
    if (typeof template === 'function') {
      return tpl;
    } else {
      return Handlebars.compile(tpl);
    }
  },
  set: function(id, template) {
    return this.templates[id] = typeof template === 'string' ? this.compile(template) : template;
  },
  get: function(nsString) {
    if (nsString == null) {
      nsString = null;
    }
    if (nsString != null) {
      return this.templates[nsString];
    } else {
      return this.templates;
    }
  },
  render: function(id, data) {
    if (this.get(id) != null) {
      return this.get(id)(data);
    } else {
      throw "Template '" + id + "' not found";
    }
  }
};
