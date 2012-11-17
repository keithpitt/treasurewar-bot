require_relative "../util/path_finder"
require "rspec"

describe PathFinder do
  describe "#calculate_directions" do
    it "gives directions to the point" do
      points = [
        Point.new(:x => 8, :y => 6),
        Point.new(:x => 7, :y => 6),
        Point.new(:x => 6, :y => 6),
        Point.new(:x => 5, :y => 6),
        Point.new(:x => 5, :y => 7),
        Point.new(:x => 5, :y => 8)
      ]

      directions = PathFinder.new(double).calculate_directions(points)

      directions.should == [:n, :n, :e, :e, :e]
    end
  end

  describe "#optimized_path" do
    it "cuts corners" do
      PathFinder.new(double).optimize_directions([:n, :n, :e, :e, :e]).should == [ :n, :ne, :e, :e ]
    end
  end
end
