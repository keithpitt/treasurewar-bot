require_relative './square'
require_relative './map'
require_relative './path_finder'

require_relative './explorer'
require_relative './wanderer'
require_relative './hunter'
require_relative './pickup'
require_relative './takeback'
require_relative './dropoff'
require_relative './stealer'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map, :player

  def initialize
    @map = Map.new
    @player = nil
    @priority = [
      Dropoff.new(self),
      Takeback.new(self),
      Pickup.new(self),
      # Stealer.new(self),
      Hunter.new(self),
      Explorer.new(self),
      Wanderer.new(self)
    ]
  end

  def tick(world)
    p "ticking #{Time.now.to_i}"
    map.clear_flags

    world.tiles.each do |point|
      map.explore point, world
    end

    @player = world.you
  end

  def decide_action(world)
    chosen = false
    action, options = nil

    @priority.each do |x|
      if !chosen && x.do_something?(world)
        p x.class.name
        action, options = x.decide_action(world)
        chosen = true
      else
        x.reset if x.respond_to?(:reset)
      end
    end

    return action, options
  end
end
