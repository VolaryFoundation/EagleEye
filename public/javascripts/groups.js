var Group = Backbone.Model.extend({
  idAttribute: '_id',
  urlRoot: "/api/groups",
  defaults: {
    "type": 'group',
    prefs: {}
  }
})

var User = Backbone.Model.extend({
  defaults: {
    "id": baked.user.id,
    "email": baked.user.email,
    "role": baked.user.role
  }
})

var Adapters = Backbone.Model.extend({
  defaults: {
    available: ['facebook', 'meetup', 'mockingbird'],
    free: [],
    used: []
  },

  update: function() {
    available = adapters.get('available')
    var used = []
    var free = []
    _.each(group.get('refs'), function(value) {
      index = _.indexOf(available, value.adapter)
      if (index != undefined) {
        used.push(available[index])
      }
    })
    _.each(available, function(value) {
      index = _.indexOf(used, value)
      if (index == -1) {
        free.push(value)
      }
    })
    adapters.set('free', free)
    adapters.set('used', used)
  }
})



