$(document).ready(function() {
  var doc = $(document)
  $('.hideable').hide();
  $('section#mockingbird_view').show();
  //Add google map to blank image.
  $(".group_img").each(function(image) {
    if (this.getAttribute('src') == 'http://placehold.it/180x125.png') {
      if (this.getAttribute('extra_info_city')) {
      	city = this.getAttribute('extra_info_city')
      	state = this.getAttribute('extra_info_state')
      	this.setAttribute('src', "https://maps.googleapis.com/maps/api/staticmap?center=" + city +',' + state + '&size=180x125&sensor=false')
      }
      else if (this.getAttribute('extra_info_state')) {
      	state = this.getAttribute('extra_info_state')
      	this.setAttribute('src', "https://maps.googleapis.com/maps/api/staticmap?center=" + state + '&size=180x125&sensor=false')
      }
    }
  });

  //Event Listenr for Edit form
  $("a.edit_link", $('section#mockingbird_view')).click(function(e) {
    e.preventDefault();
    $('section#mockingbird_view').hide();
    $('section#mockingbird_edit').show();
    $('.form.main_info_area').show().addClass('active_area');
    $('#main_info_area').addClass('active')
  })

  //Event listener for link to form show proccess
  doc.on('click', "a.form_nav_link", function(e) {
    e.preventDefault();
    $('.form.active_area').hide().removeClass('active_area')
    $('a.active').removeClass('active')
    $(e.currentTarget).addClass('active')
    $('.' + e.currentTarget.id).show().addClass('active_area')
    if(e.currentTarget.id == 'url_area') { 
      resetAll()
      setInitalUrlView()
    }
  })

  //Event listen for canel edit form
  $("a.cancel.main_info", $('section#mockingbird_edit')).click(function(e) {
    e.preventDefault();
    $('.hideable').hide();
    $('section#mockingbird_view').show();
    deactivateAll()
    resetFroms()
  })

  doc.on('click', '.cancel.url', function(e) {
    e.preventDefault();
    resetAll()
    setInitalUrlView()
  })

  //URL edit form listeners
  doc.on('click', '.edit_url_link', function(e) {
    e.preventDefault();
    resetAll()
    setInitalUrlView()
    $(e.currentTarget).parent().parent().addClass('active');
    $('#showAddForm').hide()
    $("form[group_id='" + $(e.currentTarget).attr('group_id') + "']").show().addClass('active');
  })

  //AJAX Submit
  doc.on("submit", "form.ajax_submit", function(e) {
    if ($(e.currentTarget).hasClass('link')) {
      e.preventDefault();
      url = $('input.url[type="text"]', e.currentTarget)[0].value
      responce = checkUrl(url, e);
    } else {
      ajaxSubmit(e)
    }
  });

  doc.on("click", "a.ajax_submit", function(e) {
    r = confirm('This will permanently delete this ' + $(e.currentTarget).attr('object_type') + '. Are you sure you want to do this?');
    if(r == true){
      ajaxSubmit(e)
    } else {e.preventDefault();}
  });

  //Add url create form event listener
  doc.on("click", '#showAddForm', function(e) {
    e.preventDefault();
    $(e.currentTarget).hide()
    $('#add_url_form').show()
  })
})


function checkUrl(url, e) {
   $.ajax({
    type: "GET",
    url: "/link_checker?url=" + url,
    success: function(data){
      object = JSON.parse(data)
      if (object.code == 200 && object.status == 'changed') {
        $('input.url[type="text"]', e.currentTarget)[0].value = object.url
        ajaxSubmit(e)
      } else if (object.status == "true"){
        ajaxSubmit(e)
      } else if (object.status == "false"){
        if (confirm("The url you are submiting is unreachable. Are you sure you want to submit it?")){
          ajaxSubmit(e)
        }
      }
    },
    error: function(data){
      alert(data)
    }
  });
}

function resetAll() {
    $('.hideable').hide();
    deactivateAll();
    resetFroms();
}

function setInitalUrlView(){
  $('section#mockingbird_edit').show();
  $('.url_area').show().addClass('active_area')
  $('#url_area').addClass('active')
  $('#showAddForm').show()

}

function ajaxSubmit(e) {
  e.preventDefault();
  $.ajax({
    type: "POST",
    url: "/api/groups/" + $(e.currentTarget).attr('action'),
    data: $(e.currentTarget).serialize(),
    success: function(data){
     console.log(e);
     data = JSON.parse(data);
     target = $(e.currentTarget)
     if (target.hasClass('submit_url')) {urlChangeUpdates(data)}
     else if (target.hasClass('submit_groups')) {mainInfoChangeUpdates(data);}
     else if (target.hasClass('delete_url_link')) {urlDeleteUpdate(data);}
     else if (target.hasClass('add_url_link')) {urlAddUpdate(data)}
     else if (target.hasClass('delete_group')) {groupDeleteUpdate(data)};;
    },
    error: function(data){
     if ($(e.currentTarget).hasClass('submit_url')) {
       $("#url_error").text("Unable to update the link. Please check the fields and try again").show();
     } else if ($(e.currentTarget).hasClass('submit_groups')) {
       $("#group_error").text("Unable to update the group. Please check the fields and try again").show();
     } else if ($(e.currentTarget).hasClass('url')) {
       $("#url_error").text("Can't have duplicate urls").show();
     }
    }
  });
};

function groupDeleteUpdate(data) {
  $('#frame').empty().html('<div id="page_title"><h1> Group Removed</h1><p> This group has been removed. If you believe this message is in error place contact support at {Add Email}</p></div>')
}

function buildEditLi(group, link) {
  listItem = jQuery('<li />').attr({group_id: link.id})
  theLinkDiv = jQuery('<div />').attr({class: 'url_link'}).append(jQuery('<a />').attr({href: link.url, group_id: link.id, object_id: link.id}).text(link.name))
  theActionDiv = jQuery('<div />').attr({class: 'url_action_links'})
  editLink = jQuery('<a />').attr({class: 'edit_url_link', group_id: link.id, href: link.id + '/edit', id: 'edit_url_link_' + link.id}).text('Edit')
  deleteLink = jQuery('<a />').attr({action:  group.id + '/delete_url/' + link.id, class: 'delete_url_link ajax_submit', group_id: link.id, href: link.id + '/delete', id: 'delete_url_link_' + link.id}).text('Delete')
  theActionDiv.append(editLink).append(' |').append(deleteLink)
  listItem.append(theLinkDiv).append(theActionDiv)
  return listItem
}

function urlAddUpdate(data) {
  group = data[0]; //combined in array at controller level
  link = data[1];
  $('.form.url_area').append(buildEditUrlForm(group, link));
  $('#edit_url_list').append(buildEditLi(group, link))
  $('#view_url_list').append('<li group_id= ' + link.id + '><a href=' + link.url + ' object_id= ' + link.id + ' group_id= ' + link.id + '>' + link.url + '</a></li>')
  deactivateAll()
  resetFroms();
  $('.hideable').hide();
  $('section#mockingbird_edit').show();
  $('.url_area').show().addClass('active_area')
  $('#showAddForm').show()
  $('#url_area').addClass('active')
}
function urlDeleteUpdate(data) {
  $("[group_id='" + data.id + "']").remove();
  $('.hideable').hide();
  deactivateAll()
  $('section#mockingbird_edit').show();
  $('.form.url_area').show()
  $('#url_area').addClass('active_area');
  $('#showAddForm').show()
  resetFroms();
}

function buildEditUrlForm(group, link) {
  form = jQuery('<form />').attr({action: group.id + '/url/' + link.id, method: 'post', id: 'url_edit_form_' + link.id, group_id: link.id, class: 'hidden hideable ajax_submit submit_url' })
  select = jQuery('<select />').attr({name: 'link[type]', class: 'url'})
  options = ['website', 'facebook', 'twitter', 'blog', 'calendar', 'custom']
  options.forEach(function(option){
     currentOp = jQuery('<option />').attr({value: option})
     if (currentOp.attr('value') == link.type) {
       currentOp.attr({selected: true}).text(capFirstLetter(link.type))
     }
     currentOp.appendTo(select)
  })
  input = jQuery('<input type="text" />').attr({name: 'link[url]', value: link.url, object_id: link.id, class: 'url'})
  submit = jQuery('<input type="submit" />').attr({value: 'Save'})
  cancel = jQuery('<a />').attr({href: '#mockingbird', class: 'cancel url'}).text('Cancel')
  elements = [select, input, jQuery('<br />'), jQuery('<br />'), submit, cancel]
  elements.forEach(function(element) {
    element.appendTo(form)
  })
  return form
}

function capFirstLetter(string){
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function deactivateAll() {
  $('.active').removeClass('active')
  $('.active_area').removeClass('active_area')
}


function mainInfoChangeUpdates(data) {
  $("#group_error").hide().text("");
  detailsUL = $('ul.mocking_bird_details')
  //Update Location
  locationLI = $('li.location', detailsUL)
  $('span.text', locationLI).text(locationHelper(data.location))
  //Update range
  rangeLI = $('li.range', detailsUL)
  $('span.text', rangeLI).text(data.range)
  //Update name
  nameLI = $('li.name', detailsUL)
  $('span.text', nameLI).text(data.name)
  //Update tags
  descriptionLI = $('li.description', detailsUL)
  $('span.text', descriptionLI).text(data.description)
  //Update tags
  tagsLI = $('li.tags', detailsUL)
  $('span.text', tagsLI).text(data.tags.join(", "))
  $('section#mockingbird_view').show();
  $('section#mockingbird_edit').hide();
}


function urlChangeUpdates(data) {
  resetAll()
  $("a[object_id='" + data.id + "']").attr('href', data.url)
  $("a[object_id='" + data.id + "']").text(data.url)
  $("input[object_id='" + data.id + "']").attr('value', data.url)
  $("select[object_id='" + data.id + "']").val(data.type)
  setInitalUrlView()
}

function resetFroms() {
  form = $('form')
  form.each( function(index) {
    form[index].reset();
  });
};


function locationHelper(locationObject) {
	var locationArray = []
	if (locationObject.address != null && locationObject.address != "") {
		locationArray.push(locationObject.address)
	}
	if (locationObject.city != null && locationObject.address != "") {
		locationArray.push(locationObject.city)
	}
	if (locationObject.state != null && locationObject.address != "") {
		locationArray.push(locationObject.state)
	}
	if (locationObject.postal_code != null && locationObject.address != "") {
		locationArray.push(locationObject.postal_code)
	}
	if (locationObject.country != null && locationObject.address != "") {
		locationArray.push(locationObject.country)
	}
	return locationArray.join(', ')
};

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

