class Sebastian::Plugin::Text < Sebastian::Item
  def initialize(font, text, colour)
    init = Proc.new do |state, conf|
      obj = Clutter::Text.new font, text, colour
      obj.x = 10
      obj.y = 10
      conf.stage.add_child obj
      state[:obj] = obj
    end
    super(&init)
  end

  def text_update(&block)
    on_update do |state, conf|
      @state[:obj].text = block.call(state, conf)
    end
  end
end
