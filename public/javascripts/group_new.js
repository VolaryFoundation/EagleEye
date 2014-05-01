var user = new User();
var group = new Group({refs: []});

var masshideActivate = function() {
  ui.set('groupControlFlash', false)
  ui.set('groupControlNotice', false)
  ui.set('groupControlClaimMade', false)
  ui.set('groupControlError', false)
  ui.set('groupRefFlash', false)
  ui.set('groupRefNotice', false)
  ui.set('groupControlError', false)
  ui.set('badRefError', false)
}

var UI = Backbone.Model.extend({

  defaults: {
    editMode: false,
    addRefError: false,
    isAdmin: (user.get('role') == "admin"),
    groupControlFlash: false,
    groupControlNotice: false,
    groupControlClaimMade: false,
    groupControlError: false,
    groupRefFlash: false,
    groupRefNotice: false,
    groupControlError: false,
    badRefError: false

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

  saveGroup: function() {
    masshideActivate()
    _.each(group.get('refs'), function(ref) {
      if ( ref.status == 'pending' ) { ref.status = 'approved' }
    })
    group.save(null, {
      success: function(e, obj) {
        if (typeof(baked.eagleID) == "undefined") {
          window.location.replace("/groups/" + obj._id)
        }else{
          alert("Updated")
        }
      },
      error: function(a,b,c) {
        group.set(b.responseJSON.entity)
        ui.set('groupRefError', true)
        ui.set('badRefError', true)
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
    ref['status'] = 'pending'
    refs.push(ref);
    group.set('refs', refs)
    group.trigger('change:refs')
  }
})


var ui = new UI
var adapters = new Adapters()
adapters.update()
group.on('change:refs', adapters.update)

rivets.bind(document.getElementById('frame'), {
  group: group,
  adapters: adapters,
  ui: ui
})

