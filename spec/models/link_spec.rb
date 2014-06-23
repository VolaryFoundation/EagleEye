
require 'spec_helper'

describe Link do
  
  before do
    @link = build :link
  end
  
  it 'should be valid with factory link' do 
    @link.should be_valid
  end
  
  describe 'url' do
    
    it 'should require a url' do
      @link.url = nil
      @link.should_not be_valid
    end
    
  end
  
  describe 'should require a name' do
    it 'should require a name' do
      @link.name = nil
      @link.should_not be_valid
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
