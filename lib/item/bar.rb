class Sebastian::Item::Bar < Sebastian::Item  
  @@defaults = {
    bar_color: Clutter::Color.rgb(0, 0, 0)
  }.merge(@@defaults)
  
  def initialize(options = {})
    super()
    
    @state[:options] = {
      value: 0,
      min: 0,
      max: 100,
      color: @@defaults[:bar_color]
    }.merge(options)

    value = @state[:options][:value]
    if value.is_a? Proc
      value_update do |state, main|
        value.call(state, main)
      end
      @state[:options][:valueproc] = value
      @state[:options][:value] = value.call
    end

    on_init do |state|
      opt = state[:options]
      obj = Clutter::Actor.new
      obj.layout = Clutter::FixedLayout.new
      state[:actor] = obj
    end
  end

  def value_update(&block)
    on_update do |state, main|
      state[:value] = block.call(state, main)
    end
  end
end
