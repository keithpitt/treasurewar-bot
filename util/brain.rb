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

    scope = []

    square.area.each do |coord|
      scope[coord.x] ||=[]
      scope[coord.x][coord.y] = scan coord, world

      expand coord
    end

    p scope
  end

  def scan(point, world)
    # Is it something the world knows about? Or is it the player?
    point_type = if point == world.you.position
      'player'
    else
      tile = world.tiles.find { |tile| tile == point }
      if tile
        tile.type
      else
        nil
      end
    end

    @map[point.x] ||= []
    @map[point.x][point.y] = point_type || 'space'
  end

  def expand(point)
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size
  end

  def valid_move_directions
    []
  end
end
