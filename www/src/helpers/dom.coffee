module.exports =

  getByRole: (role, parent = null, filter = '') ->
    selector = "[data-role='#{role}']#{filter}"
    if not parent? then $ selector else parent.find selector