require './lib/item/text.rb'
seb = Sebastian.new

datevar = Sebastian::Variable.new do
  Time.now
end

date = Sebastian::Item::Text.new text: (Proc.new do
  "Today at #{datevar.result}"
end)

seb.add_variable datevar, 2000
seb.add_item date
seb.start
