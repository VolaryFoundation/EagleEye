var Claim = Backbone.Model.extend({
    idAttribute: 'id',
    urlRoot: "/api/claims"
})

var Claims = Backbone.Collection.extend({
  model: Claim,
  url: '/api/claims?search=' + baked.eagleID,

  hasClaim: function() {
    return claims.find( function(claim) { 
      return (user.id == claim.get('user_id'))
    });
  },

  hasApprovedClaim: function() {
    if (user.get('role') == 'guest') {
      return false
    }else{
      result = claims.hasClaim()
    }
    if (result == undefined) {
      return false
    }else{
      return (result.get('status') == 'approved') ? true : false
    }
  }
})


var Cache = Backbone.Model.extend({
  idAttribute: '_id',
  urlRoot: baked.eagleServer + "cache"
})

var setPrefsOnCache = function() {
  _.each(group.get('prefs'), function(value, key) {
    meta = new Object(cache.get('_meta'))
    if (meta) {
      _.each(meta.fields[key], function(entry){entry['preferred'] = (entry.source == value) ? true : false})
      cache.set('_meta', meta)
    }
  })
}

var updateAdapters = function() {
  _.each(group.get('refs'), function(value) {
    adapters.set('available', _.without(adapters.get('available'), value.adapter))
  })
}



var group = new Group({_id: baked.eagleID});
groupRecieved = group.fetch()
var user = new User();
var claims = new Claims(baked.claims);
var cache = new Cache({_id: baked.eagleID})
var adapters = new Adapters()
groupRecieved.then( function() {adapters.update()})
cache.fetch({data: {type: 'group'}})
group.on('sync', setPrefsOnCache)
cache.on('sync', setPrefsOnCache)
group.on('change:prefs', setPrefsOnCache)
group.on('change:refs', adapters.update)


var masshideActivate = function() {
  ui.set('groupRefNotice', false)
  ui.set('groupClaimNotice', false)
  ui.set('groupClaimMade', false)
  ui.set('groupUpdated', false)
  ui.set('groupControlError', false)
  ui.set('groupRefFlash', false)
  ui.set('groupRefNotice', false)
  ui.set('groupControlError', false)
  ui.set('badRefError', false)
  ui.set('groupError', false)
}


var UI = Backbone.Model.extend({

  defaults: {
    editMode: false,
    addRefError: false,
    isAdmin: (user.get('role') == "admin"),
    isOwner: ((user.get('role') == "admin") || (claims.hasApprovedClaim(user.get('id')))),
    hasClaim: claims.hasClaim() != undefined,
    groupRefNotice: false,
    groupClaimNotice: false,
    groupClaimMade: false,
    groupUpdated: false,
    groupControlError: false,
    groupRefFlash: false,
    groupRefNotice: false,
    groupControlError: false,
    badRefError: false,
    groupError: false

  },

  toggleEdit: function() {
    this.set("editMode", !this.get('editMode'))
  },

  submit: function(e) {
    e.preventDefault();
    responce = group.save()
  },

  deleteRef: function(e, obj) {
    masshideActivate()
    e.preventDefault();
    refs = group.get('refs')
    refs.splice(refs.indexOf(obj.ref), 1)
    group.set('refs', refs)
    group.trigger('change:refs')
  },

  setPref: function(key, e, obj) {
    masshideActivate()
    var prefs = _.extend({}, group.get('prefs'))
    prefs[key] = obj.attr.source
    group.set('prefs', prefs)
    meta = new Object( cache.get('_meta'))
    meta['updated_at'] = new Date().getTime();
    cache.set('_meta', meta)
  },

  acceptClaim: function(e, obj) {
    masshideActivate()
    e.preventDefault();
    obj.claim.save({status: 'approved'})
  },

  rejectClaim: function(e, obj) {
    masshideActivate()
    e.preventDefault();
    obj.claim.save({status: 'rejected'})
  },

  deleteGroup: function() {
    masshideActivate()
    var r = confirm("Are you sure you want to delete this group?");
    if (r == true){
      completed = group.destroy();
      completed.then(function(){
        window.location.replace("/groups/")
      })
    }
  },

  saveGroup: function() {
    masshideActivate()
    _.each(group.get('refs'), function(ref) {
      if ( ref.status == 'pending' ) { ref.status = 'approved' }
    })
    group.save(null, {
      success: function(e, obj) {
        if (typeof(baked.eagleID) == "undefined") {
          window.location.replace("/groups/" + obj[0]._id)
        }else{
          ui.set('groupRefNotice', true)
          ui.set('groupUpdated', true)
          cache.fetch({data: {type: 'group'}})
        }
      },
      error: function(a,b,c) {
        group.set(b.responseJSON.entity)
        ui.set('groupError', true)
        ui.set('badRefError', true)
      }
    })
  },

  claimGroup: function() {
    masshideActivate()
    ui.set('hasClaim', true)
    claim = new Claim({})
    claim.set('eagle_id', baked.eagleID)
    claim.save(null, {
      success: function(e, obj) {
        claims.fetch()
        ui.set('groupClaimNotice', true)
        ui.set('groupClaimMade', true)
      }
    })
  },

  addRef: function(e, obj) {
    masshideActivate()
    e.preventDefault();
    refs = group.get('refs')
    select = document.getElementById("addRefAdapterSelect");
    adapter = select.options[select.selectedIndex].value;
    value =  document.getElementById("addRefValue")
    ref = {}
    ref['adapter'] = adapter
    ref['id'] = value.value
    ref['status'] = 'pending'
    refs.push(ref);
    group.set('refs', refs)
    group.trigger('change:refs')
  },

  clearCache: function() {
    masshideActivate()
    if (typeof(baked.eagleID) != "undefined") {
      $.ajax({
        url: baked.eagleServer + 'cache/' + baked.eagleID + '?type=group' ,
        type: 'DELETE',
        success: function(result) {
          // Do something with the result
        }
      });
    }
  }
})

var ui = new UI()

//recieved.then(function() {
  rivets.bind(document.getElementById('frame'), {
    group: group,
    claims: claims,
    cache: cache,
    adapters: adapters,
    ui: ui
  })
//})
