FactoryGirl.define do

  factory :event do
    name { Faker::Lorem.words(4).join(' ') }
    description { Faker::Lorem.paragraph([3..10].sample) }
    start_at {Faker::SC.time(2..4)}
    end_at {Faker::SC.time(5..7)}
    price {Event::PRICE_OPTIONS.sample}
    attendance {Event::ATTENDANCE_OPTIONS.sample}
    tags { Faker::SC.tags }
    factory :event_with_loc do
      after(:build) do |event|
         event.location = FactoryGirl.create(:location)
      end
    end
    
    factory :event_with_links do
       after(:build) do |event|
         ([*2..5].sample).times do
           event.links << FactoryGirl.build(:link)
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
