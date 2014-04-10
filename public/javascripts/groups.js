var Group = Backbone.Model.extend({
  idAttribute: '_id',
  urlRoot: "http://volary-eagle-staging.herokuapp.com/entities",
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


