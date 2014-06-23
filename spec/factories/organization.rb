FactoryGirl.define do
  factory :group do
    name { Faker::Lorem.characters([10..150].sample) }
    description { Faker::Lorem.paragraph([3..10].sample) }
    size { Group::SIZE_OPTIONS.sample }
    range { Group::RANGE_OPTIONS.sample }
    tags { Faker::SC.tags }
    eagle_id '52def79decef61396c0bedaf'

    factory :group_with_mock_id do
      _id '5555'
    end

    factory :group_with_loc do
       after(:build) do |org|
          org.location = FactoryGirl.create(:location)
       end
    end

    factory :group_with_links do
       after(:build) do |org|
         ([*2..5].sample).times do
           org.links << FactoryGirl.build(:link)
         end
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
