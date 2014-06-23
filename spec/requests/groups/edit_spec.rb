require 'spec_helper.rb'

describe "Group Edit" do
  before do
    @group = create :group
    @user = create :admin
    login_helper(@user.email, @user.password)
    visit "/groups/#{@group.id}"
  end

  it 'should switch to main info edit when link is clicked', vcr: true, js: true do
    page.should have_selector(:link_or_button, 'Edit fields here')
    page.should have_css('section#mockingbird_edit', visible: false)
    click_link('Edit fields here')
    page.should have_css('section#mockingbird_edit', visible: true)
  end

  it 'should update the page after main info submit', vcr: true, js: true do
    click_link('Edit fields here')
    fill_in "group[description]", with: "Testing"
    click_button "main_info_submit"
    
    page.should have_css('section#mockingbird_edit', visible: false)
    page.should have_content("Description:")
  end
end

##=========================================================================##
## This file is part of EagleEye.                                          ##
##                                                                         ##
## EagleEye is Copyright 2014 Volary Foundation and Contributors           ##
##                                                                         ##
## EagleEye is free software: you can redistribute it and/or modify it     ##
## under the terms of the GNU Affero General Public License as published   ##
## by the Free Software Foundation, either version 3 of the License, or    ##
## at your option) any later version.                                      ##
##                                                                         ##
## EagleEye is distributed in the hope that it will be useful, but         ##
## WITHOUT ANY WARRANTY; without even the implied warranty of              ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       ##
## Affero General Public License for more details.                         ##
##                                                                         ##
## You should have received a copy of the GNU Affero General Public        ##
## License along with EagleEye.  If not, see                               ##
## <http://www.gnu.org/licenses/>.                                         ##
##=========================================================================##
