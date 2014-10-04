class Sebastian::Variable
  attr_reader :result
  
  def initialize(&block)
    @block = block
    update
  end

  def update
    @result = @block.call
  end
end
