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
    point_type = 'space' # Assume the point is a floor

    # Is it something the world knows about? Or is it the player?
    if point == world.you.position
      point_type = 'player'
    else
      world.tiles.each do |tile|
        if point == tile
          point_type = tile.type
        end
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
