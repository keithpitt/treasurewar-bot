require_relative './square'
require_relative './map'
require_relative './explorer'
require_relative './wanderer'
require_relative './path_finder'
require_relative './hunter'
require_relative './pickup'
require_relative './takeback'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map, :player

  def initialize
    @map = Map.new
    @player = nil
    @priority = [
      Takeback.new(self),
      Pickup.new(self),
      Hunter.new(self),
      Explorer.new(self),
      Wanderer.new(self)
    ]
  end

  def tick(world)
    map.clear_flags

    world.tiles.each do |point|
      map.explore point, world
    end

    @player = world.you
  end

  def decide_action(world)
    should_perform = @priority.find do |x|
      x.do_something?(world)
    end

    if should_perform
      should_perform.decide_action(world)
    end
  end
end
