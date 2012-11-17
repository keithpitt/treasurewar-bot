require_relative './square'

class Map
  attr_reader :tiles, :size, :flags

  def initialize
    @tiles = []
    @flags = []
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

    store point, (point_type || 'space')
  end

  def store(point, type)
    @tiles[point.x] ||= []
    @tiles[point.x][point.y] = type

    # Expand the world
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size

    type
  end

  def clear_flags
    @flags = []
  end

  def flag(point)
    @flags[point.x] ||= []
    @flags[point.x][point.y] = true
  end

  def find(point)
    (@tiles[point.x] || [])[point.y]
  end
end
