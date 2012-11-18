class You
  attr_reader :health, :name, :carrying_treasure, :score, :position, :stash

  def initialize(hash)
    @health = hash["health"]
    @name   = hash["name"]
    @score  = hash["score"]
    @carrying_treasure = !!hash["item_in_hand"]
    @position = Point.new({ :type => 'you' }.merge(hash["position"]))
    @stash = Stash.new(hash["stash"])
  end

  def inspect
    x = super
    "(#{@name}/#{@health})#{x}"
  end
end
