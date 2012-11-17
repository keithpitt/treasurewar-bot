class Renderer
  def initialize(brain)
    @brain = brain
  end

  def world
    map = @brain.map
    size = @brain.size
    buffer = ""

    if map
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
          tile = (map[x] || [])[y]
          char = if tile == 'floor'
            ","
          elsif tile == 'player'
            "@"
          elsif tile == 'stash'
            "$"
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
