class You
  attr_reader :health, :name, :carrying_treasure, :score, :position, :stash

  def initialize(hash)
    @health = hash["health"]
    @name   = hash["name"]
    @score  = hash["score"]
    @carrying_treasure = hash["carrying_treasure"]
    @position = Point.new(hash["position"])
    @stash = Stash.new(hash["stash"])
  end
end