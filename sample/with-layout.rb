require './lib/item/text.rb'
require './lib/item/flowbox.rb'
seb = Sebastian.new
seb.stage.background_color = Clutter::Color.rgb(12, 34, 56)
#^ The easiest way so far to do anything to the stage
#  (i.e. the background everything sits on) is to go straight
#  through down to the underlying Clutter::Stage.

dfs = Sebastian::Item.defaults
dfs[:text_color] = Clutter::Color.rgb(0, 0, 255)
#^ You can set defaults

here = Sebastian::Item::Text.new text: (Proc.new do
  "Today at #{Time.now.strftime '%a %b %e %H:%M:%S'}"
end), color: Clutter::Color.rgb(255, 0, 0)
#^ Or you can set options directly

there = Sebastian::Item::Text.new text: (Proc.new do |state|
  "Today at #{`TZ=Europe/Paris date +'%a %b %e %H:%M:%S'`}".strip
  #^ The `date` command (like most) appends a newline.
end)

fooooo = Sebastian::Item::Text.new text: 'baaaaaar'
fooooo.on_init do |state|
  state[:actor].color = Clutter::Color.rgb(0, 255, 0)
  #^ You can also directly manipulate the underlying Clutter actor
end

box = Sebastian::Item::FlowBox.new
box.add_child here
box.add_child there
box.add_child fooooo

seb.add_child box
seb.start
