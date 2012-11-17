class Distance < Struct.new(:p1, :p2)
  def distance
    x = ((p2.x - p1.x) + (p2.y - p1.y)).abs
    Math.sqrt x
  end
end
