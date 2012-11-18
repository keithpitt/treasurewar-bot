class Explorer
  def initialize(brain, options = {})
    @brain = brain
  end

  def decide_action(world)
    points = @brain.map.points
    floors = points.find_all &:floor?

    unknowns = floors.map do |floor|
      square = Square.new(floor.x, floor.y, floor.x, floor.y).pad(1)

      square.area.find_all do |square|
        @brain.map.find(square).unknown?
      end
    end.flatten

    starting_point = world.you.position

    if !unknowns.empty?
      sorted_unknowns = unknowns.sort do |a, b|
        Distance.new(starting_point, a).manhatten <=> Distance.new(starting_point, b).manhatten
      end

      return 'priority', :class => PathFinder, :point => sorted_unknowns.first
    else
      false
    end
  end
end
