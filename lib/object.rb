class Sebastian::Object
  attr_accessor :id
  attr_reader :_opts

  def initialize(options = {})
    @_opts = options
    @id = (Random.rand * 10_000).round
  end

  def method_missing(name, *args, &block)
    if @_opts.keys.include? name
      @_opts[name]
    else
      send name, *args, &block
    end
  end
end
