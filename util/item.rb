require_relative "./point"

class Item < Point
  def initialize(hash)
    @type = 'item'
    super(hash)
  end
end
