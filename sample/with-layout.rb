require './lib/item/text.rb'
require './lib/item/flow_layout.rb'
seb = Sebastian.new

here = Sebastian::Item::Text.new text: (Proc.new do
  "Today at #{Time.now.strftime '%a %b %e %H:%M:%S'}"
end)

there = Sebastian::Item::Text.new text: (Proc.new do |state|
  state[:actor].y = 20 if state
  "Today at #{`TZ=Europe/Paris date +'%a %b %e %H:%M:%S'`}"
end)

layout = Sebastian::Item::Box.new
layout.add_child here
layout.add_child there

seb.add_item layout
seb.start
