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

    unknowns.each do |u|
      @brain.map.flag u, '*'
    end

    if !unknowns.empty?
      point = unknowns.sample
      return 'priority', :class => PathFinder, :point => unknowns.sample
    else
    end
  end
end
