require 'bundler'
Bundler.require :default
module Sebastian; end
require './lib/dsl'

stage = Clutter::Stage.new
stage.signal_connect 'destroy' do
  Clutter.main_quit
end

state = {
  x: 0,
  y: 0
}
settings = {
  spacing: 2
}

require './sample/text'
config = SampleConfig.new
config.render.text.each { |t|
  obj = Clutter::Text.new
  obj.text = t
  obj.y = state[:y]
  obj.x = state[:x]
  state[:y] += obj.height + settings[:spacing]
  stage.add_child obj
}

stage.show
Clutter.main
