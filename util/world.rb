require_relative "./point"
require_relative "./stash"
require_relative "./you"
require "ir_b"

class World
  attr_accessor :nearby_players, :nearby_stashes, :nearby_treasure
  attr_accessor :you
  attr_accessor :walls

  DIRECTIONS = [:n, :nw, :ne, :e, :se, :s, :sw, :w]

  def initialize(state)
    @you = You.new(state["you"])

    @walls = []
    for tile in state["tiles"]
      @walls.push Point.new(tile)
    end

    @nearby_players = []
    for player in state["nearby_players"]
      @nearby_players.push Player.new(player)
    end
  end

  def valid_move_directions
    DIRECTIONS.reject{|dir|
      @walls.include? you.position.position_after(dir)
    }
  end
end
