class Sebastian::Variable
  attr_reader :result
  
  def initialize(&block)
    @block = block
    @callbacks = []
    update
  end

  def update
    @result = @block.call
    @callbacks.each do |callback|
      callback.call(@result)
    end    
  end

  def on_update(&block)
    @callbacks.push block
  end
end
