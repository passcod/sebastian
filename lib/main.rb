class Sebastian::Main < Sebastian::Item
  attr_reader :stage

  def initialize
    super()

    @state[:intervals] = {}
    @state[:children] = []
    @state[:destroys] = []
    @state[:update_rate] = 1000

    @state[:actor] = Clutter::Stage.new

    @stage = @state[:actor]
    @stage.title = 'Sebastian'
    @stage.user_resizable = true
    @stage.signal_connect 'destroy' do
      destroy self
      Clutter.main_quit
    end

    on_init do |state|
      state[:children].each do |child|
        child.init(self)
        @stage.add_child(child.state[:actor])
      end
    end

    on_init do |state|
      Clutter::Threads.add_timeout(state[:update_rate], &Proc.new do
        update self
      end)
    end

    on_update do
      state[:children].each do |child|
        child.update(self)
      end
    end

    on_destroy do
      @state[:children].each do |child|
        child.destroy(self)
      end
    end
  end

  def add_child(child)
    @state[:children].push child
  end

  def add_variable(var, rate = nil)
    rate ||= @state[:update_rate]
    at_rate = @state[:intervals][rate]
    if at_rate
      at_rate.push var
    else
      at_rate = [var]
      Clutter::Threads.add_timeout(rate, &Proc.new do
        at_rate.each do |var|
          var.update
        end
      end)
    end
  end

  def start
    init self
    @stage.show
    Clutter.main
  end
end
