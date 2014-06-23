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

// used on rv-hide and show to check is user is logined in as well as the original check
// This will over write the orgainl entry to false if the user is not loged in.
rivets.formatters.checkLoginHide = function(val) {
  if (baked.user.role == 'guest') {
    return true
  } else {
    return val
  }
}

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

rivets.formatters.backupID = function(val) {
  if (val == undefined || val == "") {
    return group.get('_id')
  }else{
    return val
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


//=========================================================================//
// This file is part of EagleEye.                                          //
//                                                                         //
// EagleEye is Copyright 2014 Volary Foundation and Contributors           //
//                                                                         //
// EagleEye is free software: you can redistribute it and/or modify it     //
// under the terms of the GNU Affero General Public License as published   //
// by the Free Software Foundation, either version 3 of the License, or    //
// at your option) any later version.                                      //
//                                                                         //
// EagleEye is distributed in the hope that it will be useful, but         //
// WITHOUT ANY WARRANTY; without even the implied warranty of              //
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       //
// Affero General Public License for more details.                         //
//                                                                         //
// You should have received a copy of the GNU Affero General Public        //
// License along with EagleEye.  If not, see                               //
// <http://www.gnu.org/licenses/>.                                         //
//=========================================================================//

