require_relative './square'
require_relative './map'
require_relative './explorer'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map

  def initialize
    @map = Map.new
    @priority = [ Explorer.new(self) ]
  end

  def tick(world)
    map.clear_flags

    world.tiles.each do |point|
      map.explore point, world
    end
  end

  def decide_action(world)
    @priority.first.decide_action(world)
  end
end
