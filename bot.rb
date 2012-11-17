require 'SocketIO'

require_relative './util/world'

client = SocketIO.connect("http://localhost:8000") do
  before_start do
    on_message {|message| puts "incoming message: #{message}"}

    # You have about 1 second between each tick
    on_event('tick') { |game_state|
      puts "Tick received #{game_state.inspect}"

      world = World.new(game_state.first)

      # Bot logic goes here...
      if world.nearby_players.any?
        # Random bot likes to fight!
        emit("attack", {
          dir: world.nearby_players.first.direction_from(
            world.position
          )
        })
      else
        # Random bot moves randomly!
        emit("move", {
          dir: world.valid_move_directions.sample
        })
      end

      # Valid commands:
      # emit("move", {dir: "n"})
      # emit("attack", {dir: "ne"})
      # emit("pick up", {dir: "ne"})
      # emit("throw", {dir: "ne"})
    }
  end

  after_start do
    emit("set name", "my bot name")
  end
end
