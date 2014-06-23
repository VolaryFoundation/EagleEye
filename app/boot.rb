require "bundler/setup"

ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
Bundler.require
Bundler.require(ENV['RACK_ENV'].to_sym)

ROOT = File.join(File.dirname(__FILE__), '..')
APP_ROOT = File.join(File.dirname(__FILE__))

require "#{ROOT}/env" 
require "#{ROOT}/env_personal" if File.exists?("#{ROOT}/env_personal.rb")

MongoMapper.connection = Mongo::MongoClient.from_uri(ENV['DATABASE_URL'])
db_name = ENV['DATABASE_URL'][%r{/([^/\?]+)(\?|$)}, 1]
MongoMapper.database = db_name


require "#{APP_ROOT}/controllers/base.rb"
require "#{APP_ROOT}/controllers/api/api_base.rb"
Dir["#{APP_ROOT}/controllers/api/*.rb"].each {|file| require file }
Dir["#{APP_ROOT}/controllers/*.rb"].each {|file| require file }
require "#{ROOT}/config/email.rb"

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
