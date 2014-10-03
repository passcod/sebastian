require 'bundler'
Bundler.require :default
require './lib/sebastian'

if ARGV[0]
  if ARGV[0][0] != '/'
    ARGV[0] = './' + ARGV[0]
  end
  require ARGV[0]
end
