class Distance < Struct.new(:p1, :p2)
  def distance
    x = ((p2.x - p1.x) + (p2.y - p1.y)).abs
    Math.sqrt x
  end

  def manhatten
    return 0  if p1 == p2

    vertical = (p1.x - p2.x).abs
    if vertical % 3 == 0
      vertical += 1
    else
      vertical
    end

    horizontal = (p1.y - p2.y).abs
    if horizontal % 3 == 0
      horizontal += 1
    else
      horizontal
    end

    vertical + horizontal
  end
end
