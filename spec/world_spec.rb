require_relative "../util/world"
require_relative "../util/point"
require "rspec"

describe World do
  let!(:world) { World.new({
    "you" => {
      "position" => {
        "x" => 4,
        "y" => 9
      },
      "stash" => {}
    },
    "tiles" => [],
    "nearby_players" => []

  }) }

  let!(:walls) {
    [Point.new(x: 5, y: 10), Point.new(x: 3, y: 8)]
  } # SE, NW


  before do
    world.tiles = walls
  end

  describe "#valid_move_directions" do
    it "should not let you move into a wall" do
      world.valid_move_directions.should_not include(:se)
      world.valid_move_directions.should_not include(:nw)
    end

    it "should let you move in other directions" do
      world.valid_move_directions.should include(:ne)
      world.valid_move_directions.should include(:sw)
      world.valid_move_directions.should include(:s)
      world.valid_move_directions.should include(:w)
      world.valid_move_directions.should include(:n)
    end
  end
end