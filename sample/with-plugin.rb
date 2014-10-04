require './lib/item/text.rb'
seb = Sebastian.new

blue = Clutter::Color.rgb 0, 0, 255
date = Sebastian::Item::Text.new 10, 10,
  font: 'Mono 12', text: 'Date', color: blue

date.text_update do |state, conf|
  "Today at #{Time.now}"
end

seb.add_item date
seb.start
