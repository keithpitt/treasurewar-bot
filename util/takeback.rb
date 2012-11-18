require_relative './points'

class Takeback < Explorer
  def do_something?(world)
    # Currently walking?
    return true if @path_finder

    p world.you.carrying_treasure

    # Have stash?
    return true if world.you.carrying_treasure

    false
  end

  def decide_point(world)
    raise 'arg go home'
  end
end
