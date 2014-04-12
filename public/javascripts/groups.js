var Group = Backbone.Model.extend({
  idAttribute: '_id',
  urlRoot: "/api/groups",
  defaults: {
    "type": 'group'
  }
})

var User = Backbone.Model.extend({
  defaults: {
    "id": baked.user.id,
    "email": baked.user.email,
    "role": baked.user.role
  }
})


