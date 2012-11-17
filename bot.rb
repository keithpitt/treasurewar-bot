#!/usr/bin/env ruby
require 'SocketIO'

require_relative './util/world'
require_relative './util/brain'
require_relative './util/renderer'

brain = Brain.new

client = SocketIO.connect("http://localhost:8000") do
  before_start do
    on_message {|message| puts "incoming message: #{message}"}

    # You have about 1 second between each tick
    on_event('tick') { |game_state|
      world = World.new(game_state.first)
      renderer = Renderer.new(brain)

      renderer.render do
        brain.tick world

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
      end

      # Valid commands:
      # emit("move", {dir: "n"})
      # emit("attack", {dir: "ne"})
      # emit("pick up", {dir: "ne"})
      # emit("throw", {dir: "ne"})
    }
  end

  after_start do
    emit("set name", "sparrow")
  end
end
