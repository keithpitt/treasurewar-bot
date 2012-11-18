require_relative "./point"

class FakePoint < Point
  def initialize(hash)
    @type = 'fake'
    super(hash)
  end
end
