#\ -p 7000
require 'rubygems'
require 'bundler'

Bundler.setup

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'favorite_color'
run FavoriteColor::Server
