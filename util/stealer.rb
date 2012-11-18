require_relative './points'

class Stealer < Explorer
  def do_something?(world)
    # Currently walking?
    return true if @path_finder

    # Near an item
    item = closest_item(world)
    return true if item

    false
  end

  def decide_point(world)
    closest_item(world)
  end

  private

  def closest_item(world)
    Points.new(world.nearby_stashes).closest_to(world.you.position).first
  end
end
