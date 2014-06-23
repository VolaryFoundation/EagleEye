
require 'spec_helper'

describe Event do

  before do
    @event = FactoryGirl.build(:event)
  end

  describe 'name' do

    it 'should require a name' do
      @event.name = nil
      @event.should_not be_valid
    end
  end

  describe 'attendance' do

    it 'should allow attendance to be nil' do
      @event.attendance = nil
      @event.should be_valid
    end
    
    it 'should have an attendance that eqauls specific options' do
      @event.attendance = 'something wrong'
      @event.should_not be_valid
    end
  end

  describe 'price' do

    it 'should allow price to be nil' do
      @event.price = nil
      @event.should be_valid
    end

    it 'should have a size that eqauls specific options' do
      @event.price = 'something wrong'
      @event.should_not be_valid
    end
  end
  
  describe 'location' do
    it 'should be able to have a location' do
      event = build :event_with_loc
      event.should be_valid
    end
  end
  
  describe 'link' do
    it 'should be able to have a many links' do
      event = build :event_with_links
      event.should be_valid
    end
  end

  describe '.search' do

    before do
      @query = Event.build_query({
        keywords: 'Foo Bar',
        attendances: [ '1-10' ],
        prices: [ '$$' ],
        tags: { a: 'require', b: 'reject', c: '' },
        geo: [ 0.1, -0.1, 1000 ],
        keys: { a: 1, b: 2 }
      })
    end

    describe 'keywords filter' do

      it "should include formatted array of keywords in query" do
        @query[:keywords].should be == { :$in => [ 'foo', 'bar' ] }
      end
    end

    describe 'attendances filter' do

      it 'should include attnedances as part of $in array' do
        @query[:attendance].should be == { :$in => [ '1-10' ] }
      end
    end

    describe 'price filter' do

      it 'should include prices as part of $in array' do
        @query[:price].should be == { :$in => [ '$$' ] }
      end
    end

    describe 'tags filters' do

      it 'shoudl show required and rejected tags' do
        @query[:tags].should be == { :$in => [ 'a' ], :$nin => [ 'b' ] }
      end
    end

    describe 'geo filter' do

      it 'should include complex geo query' do
        @query[:'location.lng_lat'].should be == { :$near => { :$geometry => { type: 'Point', coordinates: [ 0.1, -0.1 ] } }, :$maxDistance => 0.15696123057604772 }
      end
    end

    describe 'keys filter' do

      it 'should build query correctly' do
        @query[:a].should be 1
        @query[:b].should be 2
      end
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
