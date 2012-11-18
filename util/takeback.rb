require_relative './points'

class Takeback < Explorer
  def do_something?(world)
    # Currently walking?
    return true if @path_finder

    # Have stash?
    return true if world.you.carrying_treasure

    false
  end

  def decide_point(world)
    world.you.stash
  end
end
