require_relative "./point"

class Flag < Point
  attr_reader :char
  def initialize(hash)
    @char = hash[:char]
    super(hash)
  end
end
