require 'rubygems'
require 'bundler'

Bundler.require :default

Dotenv.load

DB = Sequel.connect(ENV['DATABASE_URL'])
