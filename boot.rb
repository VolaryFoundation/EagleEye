require "bundler/setup"

ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
Bundler.require
Bundler.require(ENV['RACK_ENV'].to_sym)

API_ROOT = File.join(File.dirname(__FILE__))

require "#{API_ROOT}/env" if File.exists?("#{API_ROOT}/env.rb")

MongoMapper.connection = Mongo::MongoClient.new('localhost', 27017)
MongoMapper.database = "volary_api_#{ENV['RACK_ENV']}"

require API_ROOT + '/controllers/base'
require API_ROOT + '/controllers/events'
require API_ROOT + '/controllers/groups'
