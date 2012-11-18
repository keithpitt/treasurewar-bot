class Dropoff
  def initialize(brain)
    @brain = brain
  end

  def do_something?(world)
    p world.you.position && world.you.stash
    world.you.carrying_treasure && (world.you.position == world.you.stash)
  end

  def decide_action(world)
    return "drop", {}
  end

  private

  def on_top_of_item(world)
    world.nearby_items.find do |item|
      item == world.you.position
    end
  end
end
