var Group = Backbone.Model.extend({
  urlRoot: "http://localhost:3000/groups"
})

var group = new Group({id: theID});
group.fetch()

var UI = Backbone.Model.extend({

  defaults: {
    editMode: false
  },

  toggleEdit: function() {
    this.set("editMode", !this.get('editMode'))
  }
})

var ui = new UI

rivets.adapters[':'] = {
  subscribe: function(obj, keypath, callback) {
    obj.on('change:' + keypath, callback)
  },
  unsubscribe: function(obj, keypath, callback) {
    obj.off('change:' + keypath, callback)
  },
  read: function(obj, keypath) {
    return obj.get(keypath)
  },
  publish: function(obj, keypath, value) {
    obj.set(keypath, value)
  }
}

rivets.configure({
  handler: function(target, event, binding) {
    this.call(binding.model, event, binding.view.models)
  }
})

rivets.formatters.asAddress = function(val) {
  if (!val) return ''
  return val.address + '<br />' + val.city + ', ' + val.state
}

rivets.bind(document.getElementById('frame'), {
  group: group,
  ui: ui
})

//new (Backbone.Router.extend({
//
//  routes: {
//    "groups/:id": "getGroup"
//  },
//
//  getGroup: function (id) {
//    group.set("id", id)
//    group.fetch().success(function() {
//      group.on('change', function() {
//        group.save(null, { patch: true, silent: true })
//      })
//    })
//  }
//}))

Backbone.history.start({ pushState: true })
