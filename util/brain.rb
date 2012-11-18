require_relative './square'
require_relative './map'
require_relative './explorer'
require_relative './path_finder'

class Brain
  MAX_VIEW_DISTANCE = 3

  attr_reader :map, :player

  def initialize
    @map = Map.new
    @player = nil
    @priority = []

    new_priority Explorer
  end

  def tick(world)
    map.clear_flags

    world.tiles.each do |point|
      map.explore point, world
    end

    @player = world.you
  end

  def new_priority(klass, options = {})
    state = klass.new(self, options)
    @priority.unshift state
  end

  def finished_priority
    @priority.shift
  end

  def decide_action(world)
    action, options = @priority.first.decide_action(world)

    if action == false
      p 'finished doing something'
      finished_priority
      decide_action(world)
    elsif action.kind_of?(String)
      while action == 'priority'
        new_priority options.delete(:class), options
        action, options = @priority.first.decide_action(world)
      end

      return action, options
    end
  end
end
