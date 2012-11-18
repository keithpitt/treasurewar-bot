require_relative "./point"

class Stash < Point
  attr_accessor :treasures

  def initialize(hash)
    @treasures = hash["treasures"] || []
    @type = 'treasure'
    super(hash)
  end

  def inspect
    x = super
    "(#{@treasures.inspect})#{x}"
  end
end
