require_relative './square'
require_relative './map'
require_relative './explorer'
require_relative './wanderer'
require_relative './path_finder'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map, :player

  def initialize
    @map = Map.new
    @player = nil
    @priority = [ Explorer.new(self), Wanderer.new(self) ]
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
      x.do_something?
    end

    if should_perform
      should_perform.decide_action(world)
    end
  end
end
