module Faker
  class SC < Base
    class << self

      def tags(num=5)
       ["age.child", "age.high school", "age.college", "age.young adult", "age.18+", "age.21+", "age.seniors", "age.singles", "age.moms", "age.dads", "philosophy.secular", "philosophy.agnostic", "philosophy.atheist", "philosophy.bright", "philosophy.conservative", "philosophy.freethought", "philosophy.freemason", "philosophy.humanist", "philosophy.liberal", "philosophy.libertarian", "philosophy.naturalist", "philosophy.objectivist", "philosophy.pastafarian", "philosophy.rationalism", "philosophy.skeptic", "philosophy.transhumanist", "philosophy.unitarian", "philosophy.other philosophy", "minority group.women", "minority group.LGBT", "minority group.African", "minority group.Asian", "minority group.European", "minority group.Hispanic", "minority group.minority group", "occupation.clergy", "occupation.military", "occupation.psychic", "occupation.teacher", "occupation.therapist", "occupation.other occupation", "ex-religious.ex-religious", "ex-religious.ex-Christian", "ex-religious.ex-Islamic", "ex-religious.ex-Mormon", "ex-religious.ex-Jewish", "ex-religious.ex-cult", "event type.meeting.conference", "event type.meeting.festival", "event type.meeting.member meet", "event type.meeting.committee meet", "event type.meeting.meeting", "event type.social.social", "event type.social.party", "event type.social.outing", "event type.social.dining", "event type.social.alcohol", "event type.camp", "event type.fundraising", "event type.educational", "event type.talk.lecture", "event type.talk.debate", "event type.talk.philosophy", "event type.talk.sunday school", "event type.talk.bible study", "event type.talk.discussion", "event type.media.book", "event type.media.movie", "event type.performance.theatre", "event type.performance.music" ].sample(num)
      end

      def time(limits)
        limits.to_a.sample.hours.from_now
      end
      
      def urls(number)
        urls = Array.new
        number.times do 
          urls << Faker::Internet.url
        end
        urls
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
