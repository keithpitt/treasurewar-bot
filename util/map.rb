require_relative './square'
require_relative './flag'

class Map
  attr_reader :tiles, :size, :flags, :points

  def initialize
    @tiles = []
    @flags = []
    @points = []
    @size = 0

    @lowest_point = nil
    @highest_point = nil
  end

  def explore(point, world)
    # Is it something the world knows about? Or is it the player?
    if point.type == 'player' || point == world.you.position
      point = world.you.position
    end

    @lowest_point = Point.new(:x => point.x, :y => point.y) unless @lowest_point
    @highest_point = Point.new(:x => point.x, :y => point.y) unless @highest_point
    @lowest_point.x = point.x if point.x < @lowest_point.x
    @lowest_point.y = point.y if point.y < @lowest_point.y
    @highest_point.x = point.x if point.x > @highest_point.x
    @highest_point.y = point.y if point.y > @highest_point.y

    # Or is there treasure?
    world.nearby_items.each do |item|
      point = item if item == point
    end

    store point
  end

  def store(point)
    @tiles[point.x] ||= []
    existing = @tiles[point.x][point.y]

    if point.type == 'you'
      point = point.dup
      point.type = 'floor'
    end

    unless existing
      existing = @tiles[point.x][point.y] = point
      expand point
      @points << point
    end

    existing
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
    found = (@tiles[point.x] || [])[point.y]

    if found
      found
    else
      Point.new(:x => point.x, :y => point.y, :type => 'unknown')
    end
  end

  def expand(point)
    @size = point.x if point.x > @size
    @size = point.y if point.y > @size
  end

  def unknown_area
    Square.new(@lowest_point.x, @lowest_point.y, @highest_point.x, @highest_point.y)
  end
end
