class PathFinder
  def initialize(brain, options = {})
    @brain = brain
    @point = options[:point]

    @known = []
  end

  def decide_action(world)
    p @point

    start = world.you.position
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(Brain::MAX_VIEW_DISTANCE)

    moveable_points = scope.area.find_all do |point|
      @brain.map.find(point).walkable?
    end

    moveable_points.each do |point|
      @brain.map.flag point, '~'
    end

    @brain.map.flag @point, '!'

    # Got to position
    # @brain.finished_priority
  end
end
