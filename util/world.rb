require_relative "./point"
require_relative "./stash"
require_relative "./you"
require_relative "./item"
require_relative "./player"
require "ir_b"

class World
  attr_accessor :players, :nearby_items, :nearby_treasure, :nearby_stashes
  attr_accessor :you
  attr_accessor :tiles

  DIRECTIONS = [:n, :nw, :ne, :e, :se, :s, :sw, :w]

  def initialize(state)
    @you = You.new(state["you"])

    @tiles = []
    for tile in state["tiles"]
      type = tile['type'] || 'wall'
      @tiles.push Point.new(:x => tile['x'].to_i, :y => tile['y'].to_i, :type => type)
    end

    @players = []
    for player in state["nearby_players"]
      @players.push Player.new(player)
    end

    @nearby_stashes = []
    for item in state["nearby_stashes"]
      @nearby_stashes.push Stash.new(item)
    end

    @nearby_items = []
    for item in state["nearby_items"]
      @nearby_items.push Item.new(item)
    end
  end
end
