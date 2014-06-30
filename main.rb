require 'bundler'
Bundler.require :default
module Sebastian; end
require './lib/object'
require './lib/dsl'
require './lib/scheduler'

# Find a more clever way to handle this
# without all these ugly $globals.
$stage = Clutter::Stage.new
$stage.title = 'Sebastian'
$stage.user_resizable = true
$stage.signal_connect 'destroy' do
  Clutter.main_quit
end

$state = {
  x: 0,
  y: 0
}
$settings = {
  spacing: 2
}

require './sample/demo'
$config = SampleConfig.new
Sebastian::Scheduler.new $config

def update
  $stage.destroy_all_children
  puts $stage.inspect
  $state[:y] = 0
  $state[:x] = 0

  # Instead of doing this dumbly, render initially once. Inside dsl.rb,
  # assign a unique id to each object. Then, in main.rb, maintain a
  # reference table where each object id points to the clutter actor
  # which handles it.
  #
  # On `render`, figure out:
  # - Which objects have been added => create actors and insert them
  #   in the proper place.
  # - Which objects have been removed => destroy actors.
  # - Which objects have changed (compare the new value to the clutter
  #   model value) => modify actors.
  # Then, reflow.
  $config.render.objects.each { |o|
    puts o.inspect
    if o.type == :text
      obj = Clutter::Text.new
      obj.text = o.value
      obj.y = $state[:y]
      obj.x = $state[:x]
      $state[:y] += obj.height + $settings[:spacing]
      $stage.add_child obj
    end
  }
end

GLib::Timeout.add_seconds 1 do
  puts 'Update'
  update
  true
end

$stage.show
Clutter.main
