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
        begin
          ui.reset

          world = World.new(game_state.first)

          # Start remembering stuffs
          brain.tick world

          # Pre render
          ui.puts Renderer.new(brain).world

          # Decide the action
          action, options = brain.decide_action(world)

          # Show UI
          ui.reset
          ui.puts Renderer.new(brain).world

          # Manual move
          #directions = { UI::KEY_UP => "n" , UI::KEY_DOWN => "s",
                         #UI::KEY_LEFT => "w", UI::KEY_RIGHT => "e" }

          #if perform_key && d = directions[perform_key]
            #emit "move", :dir => d
            #perform_key = nil
          #end

          # Valid commands:
          # emit("move", {dir: "n"})
          # emit("attack", {dir: "ne"})
          # emit("pick up", {dir: "ne"})
          # emit("throw", {dir: "ne"})

          # Finally perform the action
          emit action, options if action

          ui.draw
        rescue Exception => e
          p e
          e.backtrace.each do |e|
            p e
          end
          p brain.map.tiles
          exit
        end
      }
    end

    after_start do
      emit("set name", "keithpitt")
    end
  end
end
