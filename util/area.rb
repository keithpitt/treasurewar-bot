class Area < Struct.new(:map, :square)
  def walkable_points
    square.area.find_all do |point|
      found = map.find(point)

      if found == nil
        false
      elsif point == square.center
        false
      else
        found.walkable?
      end
    end
  end
end