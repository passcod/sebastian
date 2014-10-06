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

  def init(main)
    @inits.each do |init|
      init.call(@state, main)
    end
  end

  def update(main)
    @updates.each do |update|
      update.call(@state, main)
    end
  end

  def destroy(main)
    @destroys.each do |destroy|
      destroy.call(@state, main)
    end
  end
end
