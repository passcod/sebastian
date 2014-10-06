require './lib/item/text.rb'
require './lib/item/flowbox.rb'
seb = Sebastian.new
seb.stage.background_color = Clutter::Color.rgb(12, 34, 56)
#^ The easiest way so far to do anything to the stage
#  (i.e. the background everything sits on) is to go straight
#  through down to the underlying Clutter::Stage.

# To set e.g. the text color:
dfs = Sebastian::Item.defaults
dfs[:text_color] = Clutter::Color.rgb(0, 0, 255)
#^ 1. You can set defaults

here = Sebastian::Item::Text.new text: (Proc.new do
  "Today at #{Time.now.strftime '%a %b %e %H:%M:%S'}"
end), color: Clutter::Color.rgb(255, 0, 0)
#^ 2. You can set options directly

fooooo = Sebastian::Item::Text.new text: 'baaaaaar'
fooooo.on_init do |state|
  state[:actor].color = Clutter::Color.rgb(0, 255, 0)
  #^ 3. You can directly manipulate the underlying Clutter actor
end

there = Sebastian::Item::Text.new text: (Proc.new do |state|
  "Today at #{`TZ=Europe/Paris date +'%a %b %e %H:%M:%S'`}".strip
  #^ The `date` command (like most) appends a newline, so it's
  #  useful to strip it, otherwise it might create a blank space
  #  where none is expected.
end)

# The FlowBox automatically handles laying out its children
# according to its criteria (by default, vertical orientation,
# no spacing, etc) and their properties (defaults vary but often
# are no margin, no alignment, etc).
box = Sebastian::Item::FlowBox.new
box.add_child here
box.add_child there
box.add_child fooooo

seb.on_destroy do
  # Only runs on graceful quit
  puts 'Goodbye!'
end

# Finally, add the box to the Sebastian instance,
# and start it all!
seb.add_child box
seb.start
#^ Sebastian#start is blocking, as it starts the main loop, so
#  there can be nothing beyond this point. If you want to do
#  some cleanup before quit, use Sebastian#on_destroy as above.
