require 'spec_helper'

describe User do
  
  before do
    @user = build :user
  end
  
  describe 'basic object' do
    
    it "should be valid with facotry user" do
      @user.should be_valid
    end

    it 'should require an email' do
      @user.email = nil
      @user.should_not be_valid
    end
    
    it 'should require a password' do
      @user.password = nil
      @user.should_not be_valid
    end
  end
  
  describe 'authization' do
    
    it "should be able to encrypt the password" do
      @user.password_hash.should be_nil
      @user.encrypt_password
      @user.password_hash.should_not be_nil
    end

    it 'should authorize a user with correct credintials' do
      @user.save
      test = User.authenticate(@user.email, '!QAZxsw2')
      test.should eq(@user)
    end
    
    it 'should return nill if credentials are wrong' do
      @user.save
      test = User.authenticate('Random', 'Random')
      test.should be_nil
    end
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
