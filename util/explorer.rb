class Explorer
  def initialize(brain, options = {})
    @brain = brain
  end

  def decide_action(world)
    start = world.you.position
    unknown_points = @brain.map.unknown_area.pad(1).outer_points.map { |point| @brain.map.find(point) }
    discoverable_points = unknown_points.find_all { |point| point.unknown? || point.walkable? }

    if discoverable_points.any?
      random_point = discoverable_points.sample
      return 'priority', :class => PathFinder, :point => random_point
    else
    end
  end
end
