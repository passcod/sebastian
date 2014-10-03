require './lib/plugins/text.rb'
config = Sebastian::Config.new

blue = Clutter::Color.rgb 0, 0, 255
date = Sebastian::Plugin::Text.new 'Mono 12', 'Date', blue

date.text_update do
  "Today at #{Time.now}"
end

config.add_item date
config.start
