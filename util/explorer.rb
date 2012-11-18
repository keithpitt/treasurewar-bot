class Explorer
  def initialize(brain, options = {})
    @brain = brain
  end

  def do_something?
    calc_unknowns.any? || @path_finder
  end

  def decide_point(world)
    unknowns = calc_unknowns
    if unknowns.any?
      starting_point = world.you.position
      sorted_unknowns = unknowns.sort do |a, b|
        Distance.new(starting_point, a).manhatten <=> Distance.new(starting_point, b).manhatten
      end

      sorted_unknowns.first
    end
  end

  def decide_action(world)
    if @path_finder
      tick = @path_finder.tick(world)
      if tick
        return tick
      else
        @path_finder = nil
      end
    end

    point = decide_point(world)

    if point
      @path_finder = PathFinder.new(@brain, point)
      @path_finder.tick(world)
    else
      false
    end
  end

  private

  def calc_unknowns
    points = @brain.map.points
    floors = points.find_all &:floor?

    unknowns = floors.map do |floor|
      square = Square.new(floor.x, floor.y, floor.x, floor.y).pad(1)

      square.area.find_all do |square|
        @brain.map.find(square).unknown?
      end
    end.flatten
  end
end
