require_relative "./point"

class Stash < Point
  attr_accessor :treasure
  def initialize(hash)
    @treasures = hash["treasures"]
    @type = 'treasure'
    super(hash)
  end
end
