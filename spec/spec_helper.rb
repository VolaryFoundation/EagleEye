
ENV['RACK_ENV'] = 'test'

SPEC_ROOT = File.join(File.dirname(__FILE__))
require "#{SPEC_ROOT}/../app/boot"
require "#{SPEC_ROOT}/support/faker_extras.rb"
require "#{SPEC_ROOT}/support/vcr.rb"
require "#{SPEC_ROOT}/support/login_helper.rb"

FactoryGirl.find_definitions

Capybara.app = Rack::Builder.parse_file(File.expand_path('../../config.ru', __FILE__)).first
Capybara.ignore_hidden_elements = true
Capybara.javascript_driver = :webkit

RSpec.configure do |config|

  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods

  config.after(:each) do

    MongoMapper.database.collections.each do |collection|
      unless collection.name.match(/^system\./)
        collection.remove
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
