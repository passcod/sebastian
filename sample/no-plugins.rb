seb = Sebastian.new

date = Sebastian::Item.new do |state, conf|
  blue = Clutter::Color.rgb 0, 0, 255
  
  obj = Clutter::Text.new 'Mono 12', 'Today at Now', blue
  obj.y = 10
  obj.x = 10
  conf.stage.add_child obj
  state[:obj] = obj
end

date.on_update do |state|
  state[:obj].text = "Today at #{Time.now}"
end

seb.add_item date
seb.start
