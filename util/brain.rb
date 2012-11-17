require_relative './square'

class Brain
  VIEW_DISTANCE = 2

  attr_reader :map, :size

  def initialize
    @map = []
    @size = 0
  end

  def tick(world)
    start = world.you.position
    square = Square.new(start.x, start.y, start.x, start.y)
    square.pad(VIEW_DISTANCE)

    square.area.each do |coord|
      scan coord, world
    end
  end

  def scan(point, world)
    point_type = 'floor' # Assume the point is a floor

    # Is the point our current position?
    if point == world.you.position
      point_type = 'you'
    end

    # Is the point a wall?
    world.walls.each do |wall|
      if point == wall
        point_type == 'wall'
      end
    end

    @map[point.x] ||= []
    @map[point.x][point.y] = point_type

    expand point
  end

  def expand(point)
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size
  end
end
