require_relative './positionable.rb'
class Sebastian::Item::Text < Sebastian::Item::Positionable
  def initialize(x, y, options = {})
    init = Proc.new do |state, conf|
      opt = state[:options]
      obj = Clutter::Text.new(opt[:font], opt[:text], opt[:color])
      obj.x = state[:x]
      obj.y = state[:y]
      conf.stage.add_child(obj)
      state[:obj] = obj
    end
    super(x, y, &init)

    @state[:options] = {
      font: 'Sans 12',
      text: '',
      color: Clutter::Color.rgb(0, 0, 0)
    }.merge(options)

    text = @state[:options][:text]
    if text.is_a? Proc
      text_update do |state, conf|
        text.call
      end
      @state[:options][:textproc] = text
      @state[:options][:text] = text.call
    end
  end

  def text_update(&block)
    on_update do |state, conf|
      @state[:obj].text = block.call(state, conf)
    end
  end
end
