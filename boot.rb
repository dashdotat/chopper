$stdout.sync = true
require 'rubygems'
require 'bundler'

Bundler.require :default

Dotenv.load

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => ENV['SMTP_SERVER'] || 'localhost',
    :port => ENV['SMTP_PORT'] || '25',
    :user_name => ENV['SMTP_USERNAME'],
    :password => ENV['SMTP_PASSWORD'],
  },
  :from => ENV['NOTIFICATIONS_FROM'],
  :to => ENV['NOTIFICATIONS_TO']
}
Sequel.default_timezone = :utc
DB = Sequel.connect(ENV['DATABASE_URL'])
DB.extension(:pagination)

require './lib/core_ext/string'
require './lib/poller_config'
require './lib/stomp_message'
require './lib/rtppm'
require './lib/message_processors/base'
require './lib/message_processors/rtppm'
