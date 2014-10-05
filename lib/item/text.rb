class Sebastian::Item::Text < Sebastian::Item  
  @@defaults = {
    text_font: 'Mono 12',
    text_color: Clutter::Color.rgb(0, 0, 0)
  }.merge(@@defaults)
  
  def initialize(options = {})
    super()
    
    @state[:options] = {
      font: @@defaults[:text_font],
      text: '',
      color: @@defaults[:text_color]
    }.merge(options)

    text = @state[:options][:text]
    if text.is_a? Proc
      text_update do |state, conf|
        text.call(state, conf)
      end
      @state[:options][:textproc] = text
      @state[:options][:text] = text.call
    end

    on_init do |state, conf|
      opt = state[:options]
      obj = Clutter::Text.new(opt[:font], opt[:text], opt[:color])
      state[:actor] = obj
      conf.stage.add_child(obj)
    end
  end

  def text_update(&block)
    on_update do |state, conf|
      @state[:actor].text = block.call(state, conf)
    end
  end
end
