class Sebastian::Item
  attr_reader :state
  @@defaults = {}
  def self.defaults; @@defaults; end
  
  def initialize(&block)
    @state ||= @@defaults.clone
    @inits = []
    @updates = []
    @destroys = []
    on_init(block) if block
  end

  def on_init(&block)
    @inits.push block
  end

  def on_update(&block)
    @updates.push block
  end

  def on_destroy(&block)
    @destroys.push block
  end

  def init(config)
    @inits.each do |init|
      init.call(@state, config)
    end
  end

  def update(config)
    @updates.each do |update|
      update.call(@state, config)
    end
  end

  def destroy(config)
    @destroys.each do |destroy|
      destroy.call(@state, config)
    end
  end
end
