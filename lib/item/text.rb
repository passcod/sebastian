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
      text_update do |state, main|
        text.call(state, main)
      end
      @state[:options][:textproc] = text
      @state[:options][:text] = text.call
    end

    on_init do |state|
      opt = state[:options]
      obj = Clutter::Text.new(opt[:font], opt[:text], opt[:color])
      state[:actor] = obj
    end
  end

  def text_update(&block)
    on_update do |state, main|
      @state[:actor].text = block.call(state, main)
    end
  end
end
