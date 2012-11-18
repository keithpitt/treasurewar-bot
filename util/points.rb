class Points < Struct.new(:points)
  def closest_to(p)
    sorted_unknowns = points.sort do |a, b|
      Distance.new(p, a).manhatten <=> Distance.new(p, b).manhatten
    end
  end
end
