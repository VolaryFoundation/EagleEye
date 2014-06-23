
require 'spec_helper'

describe "Rake db:" do
  
  before do
    load File.expand_path("./Rakefile")
  end
  
  describe 'seed', :speed => 'slow' do
    #it "should fill the database with test data" do
    #  Rake::Task["db:seed"].execute
    #  Group.first.should_not be_nil
    #end
  end
  
  describe 'clear', :speed => 'slow' do
    #it 'should remove all from the database' do
    #  FactoryGirl.create(:group_with_loc)
    #  FactoryGirl.create(:event_with_loc)
    #  Group.count.should be > 0
    #  Event.count.should be > 0
    #  Rake::Task["db:clear"].execute
    #  Group.count.should be == 0
    #  Event.count.should be == 0
    #end
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
