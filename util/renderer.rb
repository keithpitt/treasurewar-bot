class Renderer
  def initialize(brain)
    @brain = brain
  end

  def world
    tiles = @brain.map.tiles
    flags = @brain.map.flags
    size = @brain.map.size
    buffer = ""

    if tiles
      # Header
      buffer << "".ljust(3)
      size.times do |x|
        x = x + 1
        buffer << x.to_s.ljust(3)
      end
      buffer << "\n"

      # Down
      size.times do |y|
        y = y + 1
        buffer << y.to_s.ljust(3)

        size.times do |x|
          x = x + 1
          tile = (tiles[x] || [])[y]

          # Is this flagged?
          tile = 'flag' if (flags[x] || [])[y]

          char = if tile == 'floor'
            "."
          elsif tile == 'player'
            "@"
          elsif tile == 'stash'
            "$"
          elsif tile == 'flag'
            "!"
          elsif tile == 'wall' || tile == 'space'
            "W"
          else
            ""
          end

          buffer << char.ljust(3)
        end

        buffer << "\n"
      end

      buffer << "\n"
    end

    buffer
  end
end
