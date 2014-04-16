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

rivets.formatters.getSource = function(val, attr) {
  if (val == undefined) {
    return null
  }else{
    return val.fields[attr][0].source
  }
}

rivets.formatters.getExpires = function(val, attr) {
  if (val == undefined) {
    return null
  } else {
    return val.fields[attr][0].expires
  }
}

rivets.formatters.asDateTime = function(val) {
  if (val == undefined) {
    return null
  } else {
    return new Date(val * 1000);
  }
}

rivets.formatters.truncate = function(val, num) {
  if (val == undefined) {
    return null
  } else {
    return val.substring(0,num) + "..."
  }
}


rivets.formatters.eqPrefSource = function(val, attr) {
  return group.get('prefs')[attr] == val
}

rivets.formatters.isEmpty = function(val) {
  if (val == undefined) {
    return true
  } else {
    return val.length == 0 ? true : false
  }
}


rivets.formatters.cleanUpRef = function(val) {
  return val['adapter'] + ": " + val['id']
}

rivets.formatters.stringify = function(val) {
  return val.join(', ')
}

rivets.formatters.getAttributes = function(val, attr) {
  if (val == undefined) {
    return null
  } else {
    return val.fields[attr]
  }
}

rivets.formatters.bind = function(fn) {
  var args = [].slice.call(arguments, 1)
  return function() {
    fn.apply(null, _.flatten(args.concat(arguments)))
  }
}


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

