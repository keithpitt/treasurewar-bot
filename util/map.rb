require_relative './square'
require_relative './flag'

class Map
  attr_reader :tiles, :size, :flags

  def initialize
    @tiles = []
    @flags = []
    @size = 0
  end

  def explore(point, world)
    # Is it something the world knows about? Or is it the player?
    if point.type == 'player' || point == world.you.position
      point = world.you.position
    end

    # Or is there treasure?
    world.nearby_items.each do |item|
      point = item if item == point
    end

    store point
  end

  def store(point)
    @tiles[point.x] ||= []
    @tiles[point.x][point.y] = point
    expand point

    point
  end

  def clear_flags
    @flags = []
  end

  def flag(point, char = '!')
    @flags[point.x] ||= []
    @flags[point.x][point.y] = Flag.new(:x => point.x, :y => point.y, :type => 'flag', :char => char)
    expand point

    point
  end

  def find(point)
    (@tiles[point.x] || [])[point.y]
  end

  def expand(point)
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size
  end
end
