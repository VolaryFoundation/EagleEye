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
    used: [],
    hasFree: false
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
    adapters.set('hasFree', adapters.get('free').length != 0 ? true : false)
  },

  showRefForm: function() {
    if (ui.get('isOwner') == true) {
      return adapters.get('hasFree')
    } else {
      return false
    }
  }
})




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

