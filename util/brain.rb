require_relative './square'
require_relative './map'
require_relative './explorer'
require_relative './path_finder'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map

  def initialize
    @map = Map.new
    @priority = []

    new_priority Explorer
  end

  def tick(world)
    map.clear_flags

    world.tiles.each do |point|
      map.explore point, world
    end
  end

  def new_priority(klass, options = {})
    state = klass.new(self, options)
    @priority.unshift state
  end

  def finished_priority
    @priority.shift
  end

  def decide_action(world)
    @priority.first.decide_action(world)
  end
end
