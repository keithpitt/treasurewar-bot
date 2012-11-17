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
        buffer << x.to_s.ljust(3)
      end
      buffer << "\n"

      # Down
      size.times do |y|
        buffer << y.to_s.ljust(3)

        size.times do |x|
          tile = (map[x] || [])[y]
          char = if tile == 'floor'
            ","
          elsif tile == 'you'
            "@"
          elsif tile == 'wall'
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
