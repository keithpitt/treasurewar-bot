require_relative './points'

class Pickup
  def initialize(brain)
    @brain = brain
  end

  def do_something?(world)
    !!on_top_of_item(world)
  end

  def decide_action(world)
    item = on_top_of_item(world)

    p world.you.position
    p item
    raise 'asdf'

    return "pick up", {}
  end

  private

  def on_top_of_item(world)
    world.nearby_items.find do |item|
      item == world.you.position
    end
  end
end
