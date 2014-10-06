class Sebastian # < Sebastian::Item ?
  attr_accessor :intervals, :items, :rate, :stage

  def initialize
    @intervals = {}
    @children = []
    @destroys = []
    @rate = 1000
    
    @stage = Clutter::Stage.new
    @stage.title = 'Sebastian'
    @stage.user_resizable = true
    @stage.signal_connect 'destroy' do
      @children.each do |child|
        child.destroy(self)
      end
      @destroys.each do |destroy|
        destroy.call(self)
      end
      Clutter.main_quit
    end
  end

  def add_child(child)
    @children.push child
  end

  def add_variable(var, rate = nil)
    rate ||= @rate
    if @intervals.member? rate
      @intervals[rate].push var
    else
      @intervals[rate] = [var]
      Clutter::Threads.add_timeout(rate, &Proc.new do
        @intervals[rate].each do |var|
          var.update
        end
      end)
    end
  end

  def on_destroy(&block)
    @destroys.push block
  end

  def start
    @children.each do |child|
      child.init(self)
      @stage.add_child(child.state[:actor])
    end
    Clutter::Threads.add_timeout(@rate, &Proc.new do
      @children.each do |child|
        child.update(self)
      end
    end)
    @stage.show
    Clutter.main
  end
end

require_relative './item.rb'
require_relative './variable.rb'
