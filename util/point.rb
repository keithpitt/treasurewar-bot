require "ir_b"
require_relative "./distance"

class Point
  attr_accessor :x, :y, :type

  include Comparable

  def initialize(hash)
    @x ||= hash["x"] || hash[:x]
    @y ||= hash["y"] || hash[:y]
    @type ||= hash["type"] || hash[:type]

    raise 'need a type' unless @type
  end

  def direction_from(point)
    dx = point.x - @x
    dy = point.y - @y
    case [dx <=> 0, dy <=> 0]
    when [0, -1] then :n
    when [1, -1] then :ne
    when [1, 0] then :e
    when [1, 1] then :se
    when [0, 1] then :s
    when [-1, 1] then :sw
    when [-1, 0] then :w
    when [-1, -1] then :nw
    when [0, 0] then raise("The point at the same position")
    end
  end

  def next_to?(point)
    dx = point.x - @x
    dy = point.y - @y
    case [dx <=> 0, dy <=> 0]
    when [0, -1] then true
    when [1, -1] then true
    when [1, 0] then true
    when [1, 1] then true
    when [0, 1] then true
    when [-1, 1] then true
    when [-1, 0] then true
    when [-1, -1] then true
    when [0, 0] then false
    end
  end

  def position_after(direction)
    case direction
    when :n  then FakePoint.new(x: @x    , y: @y - 1)
    when :ne then FakePoint.new(x: @x + 1, y: @y - 1)
    when :e  then FakePoint.new(x: @x + 1, y: @y)
    when :se then FakePoint.new(x: @x + 1, y: @y + 1)
    when :s  then FakePoint.new(x: @x    , y: @y + 1)
    when :sw then FakePoint.new(x: @x - 1, y: @y + 1)
    when :w  then FakePoint.new(x: @x - 1, y: @y)
    when :nw then FakePoint.new(x: @x - 1, y: @y - 1)
    else raise("Invalid direction #{direction.to_s}")
    end
  end

  def distance_to(point)
    Distance.new(self, point).distance
  end

  def <=> (point)
    if @x == point.x && @y == point
      0
    elsif @x < point.x || @y < point
      -1
    else
      1
    end
  end

  def == (point)
    return false if point.kind_of?(NilClass)
    @x == point.x && @y == point.y
  end

  def inspect
    "(#{@type}:#{@x},#{@y})"
  end

  def walkable?
    @type && @type != 'wall'
  end

  def floor?
    @type == 'floor'
  end

  def unknown?
    @type == 'unknown'
  end
end
