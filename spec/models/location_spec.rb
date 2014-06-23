
require 'spec_helper'

describe Location do
  
  before do
    @location = build :location
  end
  
  it 'should be valid with factory location' do 
    @location.should be_valid
  end
  
  describe 'lng_lat' do
    
    it 'should require lng_lat' do
      @location.lng_lat = nil
      @location.should_not be_valid
    end
    
  end
  
  describe 'country' do
    it 'should require country' do
      @location.country = nil
      @location.should_not be_valid
    end
  end
  
  describe 'state' do
    it 'should require state if there is a city' do
      @location.state = nil
      @location.should_not be_valid
    end
    
    it 'should not require state if there is not a city' do
      @location.state = nil
      @location.city = nil
      @location.address = nil
      @location.should be_valid
      
    end
  end
  
  describe 'city' do
    it 'should require city if an address' do
      @location.city = nil
      @location.should_not be_valid
    end
    
    it 'should not require city if there is not an address' do
      @location.city = nil
      @location.address = nil
      @location.should be_valid
    end
  end
  
  describe 'postal code' do
    it 'should require a postal code if there is an address' do
      @location.postal_code = nil
      @location.should_not be_valid
    end
    
    it 'should not require postal code if there is not an address' do
      @location.postal_code = nil
      @location.address = nil
      @location.should be_valid
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
