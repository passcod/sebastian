class Sebastian::Scheduler
  def initialize(config)
    @config = config

    @config.vars.each do |k,v|
      if v[:interval].integer?
        GLib::Timeout.add_seconds v[:interval] { update_var k }
      else
        GLib::Timeout.add v[:interval] { update_var k }
      end
    end
  end

  def update_var(name)
    vars = @config.vars
    vars[name][:value] = begin
      vars[name][:block].call
    rescue StandardError => e
      puts "Error updating var #{name}: #{e.inspect}"
      vars[name][:default]
    end
    @config.vars = vars
  end
end
