require_relative './square'

class Map
  attr_reader :tiles, :size

  def initialize
    @tiles = []
    @size = 0
  end

  def explore(point, world)
    # Is it something the world knows about? Or is it the player?
    point_type = if point.type == 'player' || point == world.you.position
                   point = world.you.position
                   'player'
                 else
                   point.type
                 end

    @tiles[point.x] ||= []
    @tiles[point.x][point.y] = point_type || 'space'

    # Expand the world
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size
  end

  def find(point)
    (@tiles[point.x] || [])[point.y]
  end
end
