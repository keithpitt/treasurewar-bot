require_relative "./point"
require_relative "./stash"
require_relative "./you"
require_relative "./item"
require "ir_b"

class World
  attr_accessor :nearby_players, :nearby_items, :nearby_treasure
  attr_accessor :you
  attr_accessor :tiles

  DIRECTIONS = [:n, :nw, :ne, :e, :se, :s, :sw, :w]

  def initialize(state)
    @you = You.new(state["you"])

    @tiles = []
    for tile in state["tiles"]
      @tiles.push Point.new(tile)
    end

    @nearby_players = []
    for player in state["nearby_players"]
      @nearby_players.push Player.new(player)
    end

    @nearby_items = []
    for item in state["nearby_items"]
      @nearby_items.push Item.new(item)
    end
  end
end
