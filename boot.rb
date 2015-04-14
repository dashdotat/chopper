require 'rubygems'
require 'bundler'
require 'json'

Bundler.require :default

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])

require './lib/core_ext/string'
require './lib/poller_config'
require './lib/stomp_message'
require './lib/message_processors/base'
require './lib/message_processors/rtppm'
