require_relative "./point"

class Player < Point
  attr_reader :health, :name, :carrying_treasure, :score
  def initialize(hash)
    @health = hash["health"]
    @name   = hash["name"]
    @score  = hash["score"]
    @carrying_treasure = hash["carrying_treasure"]
    self.x  = hash['position']['x']
    self.y  = hash['position']['y']

    super(hash)
  end

  def carrying_treasure?
    @carrying_treasure
  end

  def inspect
    x = super
    "(#{@name}/#{@health})#{x}"
  end
end
