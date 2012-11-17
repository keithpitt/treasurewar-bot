class Explorer
  def initialize(brain, options = {})
    @brain = brain
  end

  def decide_action(world)
    return 'move', :dir => random_direction(world)
  end

  def random_direction(world)
    start = world.you.position
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(Brain::MAX_VIEW_DISTANCE + 1)

    random_point = scope.outer_points.sample

    @brain.new_priority PathFinder, :point => random_point

    if false
      # Find all the floor tiles
      points = scope.area.find_all do |coord|
        @brain.map.find(coord) == 'floor'
      end

      outliers.each do |point|
        @brain.map.flag point
      end

      # Choose somewhere to go
      point = points.sample

      start.direction_from(point)
    end
  end
end
