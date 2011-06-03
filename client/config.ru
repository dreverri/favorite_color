#\ -p 7001
require 'rubygems'
require 'bundler'

Bundler.setup
require './client'
run FavoriteColor::Client
