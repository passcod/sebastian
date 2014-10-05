class Sebastian::Item
  attr_reader :state
  
  def initialize(&block)
    @state ||= {}
    @init = block
    @update = nil
    @destroy = nil
  end

  def on_update(&block)
    @update = block
  end

  def on_destroy(&block)
    @destroy = block
  end

  def init(config)
    @init.call(@state, config)
  end

  def update(config)
    @update.call(@state, config) if @update
  end

  def destroy(config)
    @destroy.call(@state, config) if @destroy
  end
end
