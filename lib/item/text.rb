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
    @state[:text] = if text.is_a? Proc
      text
    else
      Proc.new do text end
    end

    on_init do |state, main|
      opt = state[:options]
      obj = Clutter::Text.new(
        opt[:font], state[:text].call(state, main), opt[:color])
      state[:actor] = obj
    end

    on_update do |state, main|
      state[:actor].text = state[:text].call(state, main)
    end
  end

  def text_update(&block)
    @state[:text] = block
  end
end
