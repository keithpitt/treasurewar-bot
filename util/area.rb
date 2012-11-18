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

  def kind_of_walkable_points
    square.area.map do |point|
      found = map.find(point)

      if found && (found.walkable? || found.unknown?) && found != square.center
        found
      end
    end.compact
  end
end
