class Wanderer < Explorer
  def do_something?
    true
  end

  def decide_point(world)
    walkable = @brain.map.points.find_all do |t|
      t.walkable? && t != world.you.position
    end

    walkable.sample
  end
end
