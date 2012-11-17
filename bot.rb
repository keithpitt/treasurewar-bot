#!/usr/bin/env ruby
require 'SocketIO'

require_relative './util/world'
require_relative './util/brain'
require_relative './util/renderer'
require_relative './util/ui'
require_relative './util/ui_basic'

brain = Brain.new
ui = UIBasic.new

perform_key = nil
ui.on_key do |key|
  perform_key = key
  ui.puts key
end

ui.start do
  client = SocketIO.connect("http://localhost:8000") do
    before_start do
      # on_message {|message| puts "incoming message: #{message}"}

      # You have about 1 second between each tick
      on_event('tick') { |game_state|
        ui.reset

        world = World.new(game_state.first)

        # Start remembering stuffs
        brain.tick world

        # Manual move
        directions = { UI::KEY_UP => "n" , UI::KEY_DOWN => "s",
                       UI::KEY_LEFT => "w", UI::KEY_RIGHT => "e" }

        if perform_key && d = directions[perform_key]
          emit "move", :dir => d
          perform_key = nil
        end

        if true
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

        # Show UI
        ui.puts Renderer.new(brain).world

        ui.draw

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
end
