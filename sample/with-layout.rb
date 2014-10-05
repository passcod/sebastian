require './lib/item/text.rb'
require './lib/item/box.rb'
seb = Sebastian.new
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

box = Sebastian::Item::Box.new
box.add_child here
box.add_child there
box.add_child fooooo

seb.add_item box
seb.start
