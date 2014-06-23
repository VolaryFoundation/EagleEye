require 'rake'
require "rexml/document"
require './app/boot'

task :spec do
  system('rspec --color --format d ./spec')
end

namespace :db do

    task :load_factory do
      require 'faker'
      require "./spec/faker_extras.rb"
      require 'factory_girl'
      FactoryGirl.find_definitions
    end

    desc "load test data for the entire application"
    task :seed => :load_factory do
      random_group_number = [*5..10].sample
      random_group_number.times do |index|
        org = FactoryGirl.build(:group_with_loc, name: "Test Group ##{index + 1}")
        if org.save
          random_event_number = [*2..6].sample
          random_event_number.times do |eindex|
            event = FactoryGirl.create(:event_with_loc, name: "Test Event ##{index + 1}-#{eindex + 1}")
          end
        end
      end
      tags = ["age.child", "age.high school", "age.college", "age.young adult", "age.18+", "age.21+", "age.seniors", "age.singles", "age.moms", "age.dads", "philosophy.secular", "philosophy.agnostic", "philosophy.atheist", "philosophy.bright", "philosophy.conservative", "philosophy.freethought", "philosophy.freemason", "philosophy.humanist", "philosophy.liberal", "philosophy.libertarian", "philosophy.naturalist", "philosophy.objectivist", "philosophy.pastafarian", "philosophy.rationalism", "philosophy.skeptic", "philosophy.transhumanist", "philosophy.unitarian", "philosophy.other philosophy", "minority group.women", "minority group.LGBT", "minority group.African", "minority group.Asian", "minority group.European", "minority group.Hispanic", "minority group.minority group", "occupation.clergy", "occupation.military", "occupation.psychic", "occupation.teacher", "occupation.therapist", "occupation.other occupation", "ex-religious.ex-religious", "ex-religious.ex-Christian", "ex-religious.ex-Islamic", "ex-religious.ex-Mormon", "ex-religious.ex-Jewish", "ex-religious.ex-cult", "event type.meeting.conference", "event type.meeting.festival", "event type.meeting.member meet", "event type.meeting.committee meet", "event type.meeting.meeting", "event type.social.social", "event type.social.party", "event type.social.outing", "event type.social.dining", "event type.social.alcohol", "event type.camp", "event type.fundraising", "event type.educational", "event type.talk.lecture", "event type.talk.debate", "event type.talk.philosophy", "event type.talk.sunday school", "event type.talk.bible study", "event type.talk.discussion", "event type.media.book", "event type.media.movie", "event type.performance.theatre", "event type.performance.music", "event type.performance.choir", "event type.performance.comedy", "event type.performance.community.parade", "event type.performance.community.volunteer", "event type.performance.community.outreach", "event type.performance.community.rally", "event type.performance.community.community", "event type.performance.political", "event type.performance.sports", "topics", "topics.12-step", "topics.blog", "topics.business", "topics.church/state", "topics.civil rights", "topics.environment", "topics.family", "topics.feminism", "topics.government", "topics.health", "topics.history", "topics.homeschool", "topics.human rights", "topics.humor", "topics.law", "topics.military", "topics.politics", "topics.psychology", "topics.reddit", "topics.religion.Christian", "topics.religion.Jewish", "topics.religion.Islamic", "topics.religion.Buddhist", "topics.religion.cult", "topics.religion.religion", "topics.science", "topics.self-help", "topics.sexuality", "other.public transit", "other.handicapped access", "other.pet friendly", "other.child care", "other.free parking"] 
      tags.each { |t| Tag.create( name: t ) }
    end

    desc "Clear the database"
    task :clear do
      MongoMapper.database.collections.each do |collection|
        unless collection.name.match(/^system\./)
          collection.remove
        end
      end
    end
end

desc "load test groups from alldata.xml"
task :import_groups do
  require "rexml/document"
  include REXML
  file = File.new("test.xml")
  content = file.read
  @doc = Document.new(content.force_encoding("ISO-8859-1").encode("UTF-8"))

  @doc.root.elements[1].elements.each do |group|
    the_group = Group.new() #Form new group to create based of doc item
    group.elements.each do |element|
      if element.name == 'column'
        element_name =  element.attributes['name']
      else
        element_name =  element.name
      end
      custom_links = ['public_contact_url','atheist_nexus', 'twitter', 'magazine', 'newsletter', 'book']
      blog_links = ['blog', 'youtube']
      other_links = ['url', "calendar", "podcast", "facebook", "meetup"]
      if element.text.present?
        #Name
        the_group.name = element.text.strip if element_name == 'name'
        the_group.cor_id = element.text.strip if element_name == 'cor_id'
        the_group.email = element.text.strip if element_name == 'email'
        the_group.memebership element.text.strip if element_name == 'current_memebership'
        the_group.founded = element.text.strip if element_name == 'date_founded'
        the_group.description = element.text.strip if element_name == 'description'
        #Range
        the_group.range = element.text.downcase if element_name == 'size'
        #Tags
        if element_name == 'other_tags' ||  element_name == 'philosophy_tag'
          the_group.tags = the_group.add_tags(element.text.gsub(" ", '').split(','))
        end
        #Links
        if custom_links.concat(blog_links).concat(other_links).include?(element_name)
          array_of_links = element.text.split(/,/)
          array_of_links.each do |the_link|
            the_group.links.build(name: the_link, url: the_link, type: 'Website') if element_name == "website"
            the_group.links.build(name: the_link, url: the_link, type: 'Facebook') if element_name == "facebook"
            the_group.links.build(name: the_link, url: the_link, type: 'Calendar') if  element_name == "calendar"
            the_group.links.build(name: the_link, url: the_link, type: 'Blog') if blog_links.include?(element_name)
            the_group.links.build(name: the_link, url: the_link, type: 'Other') if custom_links.include?(element_name)
            the_group.links.build(name: the_link, url: the_link, type: 'Podcast') if element_name == "podcast"
            the_group.links.build(name: the_link, url: the_link, type: 'Meetup') if element_name == "meetup"

          end
        end
        #Location
        if element_name == "address" && element.text.present?
          results = Geocoder.search(element.text).first
          unless results.nil?
            location = Location.new()
            location.state = results.state if results.state.present?
            location.country = results.country if results.country.present?
            location.city = results.city if results.city.present?
            location.postal_code = results.postal_code if results.postal_code.present?
            location.address = results.street_address if results.street_address.present?
            location.lng_lat = [results.longitude, results.latitude]
            if location.valid?
              the_group.location = location
              the_group.save
              puts " #{location.address}, #{location.city}, #{location.state}, #{location.country}"
            end
          end
          sleep(1.0/10.0)
        end
      end
    end
    #Check if group exist.
    record = Group.match_group(the_group)
    if record
      record.name = the_group.name
      record.range = the_group.range unless the_group.range.nil? || the_group.range.empty?
      record.tags =  record.add_tags(the_group.tags)
      record.location = the_group.location
      the_group.links.each do |link|
        record.links << link unless record.links.include?(link)
      end
      if record.save!
        puts "Updated group: #{record.name}"
      else
        puts "Failed to update group"
      end
    else
      the_group.range = 'local' if the_group.range.nil? || the_group.range.empty?
      if the_group.save!
        puts "Create group with name: #{the_group.name}"
      else
        puts "Failed to create group"
      end
    end
    puts "==============Next Group=============="

  end
end

 task :sync_to_eagle do
  refsets = Group.all.to_a.inject([]) do |groups, group|

    data = {}

    # facebook
    fb_link = group.links.select { |l| l.type == 'Facebook' }.first
    if fb_link
      data[:facebook] = fb_link[:url]
    end

    # meetup
    meetup_link = group.links.select { |l| l.to_json.contains('Meetup') }.first
    if meetup_link
      data[:meetup] = meetup_link[:url]
    end

    # mockingbird
    data[:mockingbird] = group.id

    groups << data

    groups
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
