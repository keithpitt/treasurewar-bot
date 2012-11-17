require_relative './square'

class Brain
  VIEW_DISTANCE = 3

  attr_reader :map, :size

  def initialize
    @map = []
    @scope = nil
    @size = 0
  end

  def tick(world)
    world.tiles.each do |point|
      explore point, world
    end
  end

  def explore(point, world)
    # Is it something the world knows about? Or is it the player?
    point_type = if point.type == 'player' || point == world.you.position
                   point = world.you.position
                   'player'
                 else
                   point.type
                 end

    @map[point.x] ||= []
    @map[point.x][point.y] = point_type || 'space'

    # Expand the world
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size

    @map[point.x][point.y]
  end

  def find(point)
    (@map[point.x] || [])[point.y]
  end

  def random_direction(world)
    start = world.you.position
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(1)

    # Find all the floor tiles
    points = scope.area.find_all do |coord|
      find(coord) == 'floor'
    end

    # Choose somewhere to go
    point = points.sample

    start.direction_from(point)
  end
end
