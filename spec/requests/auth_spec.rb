require 'spec_helper.rb'

describe "Auth System" do
  it 'should reject bad email or password' do
    visit '/login'
    expect(page).to have_content 'Reset Password'
    fill_in 'user[email]',  :with => 'test@example.com'
    fill_in 'user[password]',   :with => '!QAZxsw2'
    click_button('Login')
    expect(page).to have_content 'Invalid email or password'
  end

  it 'should login in a valid user' do
    user = create :user
    visit '/login'
    fill_in 'user[email]',  :with => user.email
    fill_in 'user[password]',   :with => user.password
    click_button('Login')
    expect(page).to have_content 'You are now loged in'
    expect(page).to have_content user.email
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
