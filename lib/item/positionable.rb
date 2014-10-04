class Sebastian::Item::Positionable < Sebastian::Item
  def initialize(x, y, &block)
    super(&block)
    @state[:x] = x
    @state[:y] = y
  end
end
