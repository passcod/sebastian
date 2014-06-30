class Sebastian::DSL
  def initialize
    @text = []
  end

  def render
    instance_eval &@@display
    self
  end

  def text(text = nil)
    return @text if text.nil?
    @text.push text
  end

  def var(name)
    vars = @@vars
    if !vars.nil? and vars.keys.include? name
      vars[name][:value]
    end
  end

  def vars; @@vars; end
  def vars=(v); @@vars = v; end

  class << self
    def display(&block)
      @@display = block
    end

    def var(name, interval = 1, default = nil, &block)
      @@vars ||= {}
      @@vars[name] = {
        interval: interval,
        default: default,
        value: default,
        block: block
      }
    end
  end
end
