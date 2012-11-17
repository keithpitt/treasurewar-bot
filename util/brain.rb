require_relative './square'
require_relative './map'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map

  def initialize
    @map = Map.new
  end

  def tick(world)
    world.tiles.each do |point|
      map.explore point, world
    end
  end

  def random_direction(world)
    start = world.you.position
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(1)

    # Find all the floor tiles
    points = scope.area.find_all do |coord|
      map.find(coord) == 'floor'
    end

    # Choose somewhere to go
    point = points.sample

    start.direction_from(point)
  end

  def decide_action(world)
    return 'move', :dir => random_direction(world)
  end
end
