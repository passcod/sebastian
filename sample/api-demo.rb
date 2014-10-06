# Only the core is available by defaults; this may change in the
# future. For the moment, FlowBox and Text, the two basic blocks
# of a 'typical' Sebastian display, have to be required manually.
require './lib/item/flowbox.rb'
require './lib/item/text.rb'

# There are a few other extra ones available as a kind of
# 'standard library' for Sebastian, like for example this Bar,
# which looks and acts like Conky's `${bar …}` object.
require './lib/item/bar.rb'

#^ This being a development demo, the requires use relative
#  paths from the root of the repo, but as soon as the first
#  release is here, they will morph into the gem form, e.g.:
#    require 'sebastian/item/bar'

# To start, create a new Sebastian instance:
seb = Sebastian.new

# To set the background color, you have (for now, this will
# change) to access the underlying Clutter 'stage'. Writing
# a Sebastian config doesn't require you to understand how
# Clutter (the graphics layer it uses) works, but it's not
# completely abstracted away so if you want, you can access
# it and hack around. A lot of it is intuitive, though, like:
seb.stage.background_color = Clutter::Color.parse '#002b36'

# The `#stage` property above is just a shortcut for the
# universal `#state[:actor]`. Every item has a `#state[:actor]`
# property, which allows access to Clutter as explained above,
# and the main Sebastian instance is really just a special item.
seb.state[:actor].width = 360
seb.state[:actor].height = 100

# Each kind of Item has a number of default options that can
# be set. These are all easily accessible from a single point:
default = Sebastian::Item.defaults

# For example, to set the default text color, and font:
default[:text_color] = Clutter::Color.parse '#ffffff'
default[:text_font] = 'Inconsolata 11' # That's size 11 in pixels

# Adding items consists of two steps: creating the item, and
# adding it as a child of a Box or of the window. Additionally,
# you may specify options on the item and/or 'live' values, which
# change at every update cycle (by default 1 second).
clock = Sebastian::Item::Text.new
clock.state[:options][:color] = Clutter::Color.parse '#859900'

# To change the text at every update cycle, there's an easy way:
clock.text_update do
  Time.now.strftime '%H:%M:%S'
end
#^ There's also a hard(er) way: `clock.state[:text] = Proc.new…`
#  and an even easier way that we'll see later.

# Changing the position of the item can't be done at declare-time
# so you have to change it at init-time, like so:
clock.on_init do |state|
  state[:actor].x = 300
end

# And finally, add the item to the window:
seb.add_child clock


# As soon as we have more than one or two items, positioning
# them by hand is going to be tedious. For this reason, the
# FlowBox is very useful, as it takes care of layout for us:
box = Sebastian::Item::FlowBox.new

# There's a shorthand for Text items, you can specify the text
# when you create the item. And because you don't need to do
# anything else to it, you can add it to the box straight away:
box.add_child Sebastian::Item::Text.new  text: 'My own Sebastian'

# Same with dynamic Text items:
box.add_child Sebastian::Item::Text.new text: (Proc.new do
  memusage = `ps -o rss -p #{$$}`.strip.split.last.to_i
  "This Sebastian is using #{memusage}KB of RAM"
  #^ Which will show you just how much it's leaking ><
end)

# You can also modify different properties, not just the text,
# on an update:
random = Sebastian::Item::Text.new text: 'Random Color!'
random.on_update do |state|
  co = ['#b58900', '#cb4b16', '#dc322f', '#d33682',
        '#6c71c4', '#268bd2', '#2aa198', '#859900'].shuffle.first
  state[:actor].color = Clutter::Color.parse co
end
box.add_child random

# If you want to have a dynamic value that will take more than
# the update rate (more than a second) to update, for example
# request to a web service, you have to use a Variable.
# A Variable lets you have a value updated at a different rate,
# but still be usable by any item, without making the entire
# thing grind to a halt whenever it takes too long.
name = Sebastian::Variable.new do
  `curl -sm 4 www.pseudorandom.name`.strip
  #^ Strip is used as many cli programs append a newline
  #  The `-sm 4` flags are for silent operation and a four
  #  seconds time limit on the HTTP request.
end

# The different update rate is specified in milliseconds:
seb.add_variable name, 5000

box.add_child Sebastian::Item::Text.new text: '------------'
box.add_child Sebastian::Item::Text.new text: 'Random name:'
box.add_child Sebastian::Item::Text.new text: (Proc.new do
  name.result
end)

# Adding the FlowBox to the main window is done as usual:
seb.add_child box

# And finally, everything can start!
seb.start
#^ This is blocking, so it must be the last statement here.
