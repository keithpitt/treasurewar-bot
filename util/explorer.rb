class Explorer
  def initialize(brain, options = {})
    @brain = brain
  end

  def decide_action(world)
    start = world.you.position
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(Brain::MAX_VIEW_DISTANCE)

    moveable_points = scope.outer_points.find_all { |point| @brain.map.find(point).walkable? }
    random_point = moveable_points.sample

    return 'priority', :class => PathFinder, :point => random_point
  end
end
