require './lib/item/text.rb'
seb = Sebastian::Config.new

date = Sebastian::Item::Text.new text: (Proc.new do
  "Today at #{Time.now}"
end)

seb.add_item date
seb.start
