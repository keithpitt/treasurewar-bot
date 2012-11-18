class Attacker
  def initialize(brain)
    @brain = brain
  end

  def do_something?(world)
    !!next_to_enemy(world)
  end

  def decide_action(world)
    player = world.you.position
    enemy = next_to_enemy(world)
    attack_direction = player.direction_from(enemy)

    return "attack", { dir: attack_direction }
  end

  private

  def next_to_enemy(world)
    player = world.you.position

    square = Square.new(player.x, player.y, player.x, player.y).pad(1)
    enemies = []

    square.outer_points.each do |point|
      world.players.each do |enemy|
        if point == enemy
          enemies.push enemy
        end
      end
    end

    enemies.sample
  end
end
