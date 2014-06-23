$(document).ready(function() {
	
  // Submit link as a post for logout (as well as claim and accept user on groups)
  $('a.act_as_form').click(function(e) {
	e.preventDefault();
	$.ajax({
      type: $(this).attr('_method'),
      url: $(this).attr('href'),
	  success: function(data){
		window.location.href = JSON.parse(data)
      },
      error: function(data){
	    //TODO add in a failure option. Right now this should not fail.
      }
    })
  })

  //Nav dropdown menues.
  $('li.main_nav').hover(
	function(e) {
	  $(this).find('ul').show()
	}, function(e) {
	  $(this).find('ul').hide()
	})
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

