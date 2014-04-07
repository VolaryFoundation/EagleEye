var Group = Backbone.Model.extend({
  idAttribute: '_id',
  urlRoot: "http://localhost:3000/entities"
})



if (typeof(baked.eagleID) != "undefined") {
  var group = new Group({_id: baked.eagleID});
  done = group.fetch()
  var Claim = Backbone.Model.extend({
    idAttribute: 'id',
    urlRoot: "/api/claims"
  })

  var Claims = Backbone.Collection.extend({ 
    model: Claim,
    url: '/api/claims?search=' + baked.eagleID,
  })

  var claims = new Claims();

  claims.fetch()

} else {
  var group = new Group({refs: []});
};

var UI = Backbone.Model.extend({

  defaults: {
    editMode: false,
    addRefError: false
  },

  toggleEdit: function() {
    this.set("editMode", !this.get('editMode'))
  },

  submit: function(e) {
    e.preventDefault();
    responce = group.save()
  },

  deleteRef: function(e, obj) {
    e.preventDefault();
    refs = group.get('refs')
    refs.splice(refs.indexOf(obj.ref), 1)
    group.set('refs', refs)
    group.trigger('change:refs')
  },

  acceptClaim: function(e, obj) {
    e.preventDefault();
    obj.claim.save({status: 'approved'})
  },

  rejectClaim: function(e, obj) {
    e.preventDefault();
    obj.claim.save({status: 'rejected'})
  },

  deleteGroup: function() {
    var r = confirm("Are you sure you want to delete this group?");
    if (r == true){
      group.destroy([{
        success: function(obj, responce){
          window.location.replace("http://localhost:9393/groups")
        }
      }])
    }
  },

  saveGroup: function() {
    group.save(null, {
      success: function(e, obj) {
        if (typeof(baked.eagleID) == "undefined") {
          window.location.replace("http://localhost:9393/groups/" + obj[0]._id)
        }else{
          alert("Updated")
        }
      }
    })
  },

  claimGroup: function() {
    claim = new Claim({})
    claim.set('eagle_id', baked.eagleID)
    claim.save(null, {
      success: function(e, obj) {
        claims.fetch()
      }
    })
  },

  addRef: function(e, obj) {

    e.preventDefault();
    refs = group.get('refs')
    select = document.getElementById("addRefAdapterSelect");
    adapter = select.options[select.selectedIndex].value;
    value =  document.getElementById("addRefValue")
    ref = {}
    ref['adapter'] = adapter
    ref['id'] = value.value
    refs.push(ref);
    group.set('refs', refs)
    group.trigger('change:refs')
  }
})

var ui = new UI

rivets.adapters[':'] = {
  subscribe: function(obj, keypath, callback) {
    obj.on('change:' + keypath, callback)
    if (obj instanceof Backbone.Collection){
      obj.on('reset sync add', callback)
    }
  },
  unsubscribe: function(obj, keypath, callback) {
    obj.off('change:' + keypath, callback)
    if (obj instanceof Backbone.Collection){
      obj.off('reset sync add', callback)
    }
  },
  read: function(obj, keypath) {
    console.log(obj);
    return obj instanceof Backbone.Collection ? obj.models : obj.get(keypath);
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
  var loc = []
  if (val.address) loc.push(val.address)
  if (val.city) loc.push(val.city)
  if (val.state) loc.push(val.state)

  return loc.join(', ')
}

rivets.formatters.cleanUpRef = function(val) {
  return val['adapter'] + ": " + val['id']
}

rivets.formatters.stringify = function(val) {
  return val.join(', ')
}

rivets.bind(document.getElementById('frame'), {
  group: group,
  claims: claims,
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
