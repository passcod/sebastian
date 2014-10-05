class Sebastian::Item::Box < Sebastian::Item
  @@defaults = {
    box_spacing: 0
  }.merge(@@defaults)
  
  def initialize
    super()

    @state[:children] = []
    @state[:height] = 0
    @state[:spacing] = @@defaults[:box_spacing]

    on_init do |state, conf|
      box = Clutter::Actor.new
      box.layout_manager = Clutter::FixedLayout.new
      #^ I couldn't make other layouts work magically,
      #  so picking this one and managing the visual
      #  lay of the land ourselves will do fine for now.
      #  HELPWANTED for anyone who knows how to make
      #  something like Clutter::FlowLayout work properly.

      conf.stage.add_child(box)
      state[:actor] = box
      init_children(conf)
    end

    on_update do |state, conf|
      state[:children].each do |child|
        child.update(conf)
      end
    end
  end

  def init_children(conf)
    @state[:children].each do |child|
      child.init(conf)
      add_child(child)
    end
  end

  def add_child(child)
    kids = @state[:children]
    kids.push(child) unless kids.include? child
    #^ That guarantees @state[:children] to be
    #  a unique set, but if a child is added twice
    #  it means that the array won't reflect the
    #  actual layout as seen on screen.

    if @state.member? :actor
      act = child.state[:actor]
      if act.is_a? Clutter::Actor
        act.y = @state[:height]
        @state[:height] += act.height + @state[:spacing]
        @state[:actor].add_child(act)
      else
        puts "Expected Clutter::Actor, found #{act.inspect}."
      end
    end
  end
end
