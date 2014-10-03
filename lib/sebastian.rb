module Sebastian
  module Plugin
  end

  class Config
    attr_accessor :items, :rate, :stage

    def initialize
      @items = []
      @rate = 1000
      
      @stage = Clutter::Stage.new
      @stage.title = 'Sebastian'
      @stage.user_resizable = true
      @stage.signal_connect 'destroy' do
        @items.each do |item|
          item.destroy(self)
        end
        Clutter.main_quit
      end
    end

    def add_item(item)
      @items.push item
    end

    def start
      @items.each { |item| item.init(self) }
      Clutter::Threads.add_timeout(@rate, &Proc.new do
        @items.each do |item|
          item.update(self)
        end
      end)
      @stage.show
      Clutter.main
    end
  end

  class Item
    def initialize(&block)
      @state = {}
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
end
