class Renderer
  def initialize(brain)
    @brain = brain
    clear
  end

  def render(&block)
    clear
    yield

    map = @brain.map
    size = @brain.size
    if map
      # Header
      print "".ljust(3)
      size.times do |x|
        print x.to_s.ljust(3)
      end
      print "\n"

      # Down
      size.times do |y|
        print y.to_s.ljust(3)

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

          print char.ljust(3)
        end

        print "\n"
      end

      print "\n"
    end
  end

  def clear
    puts "\e[H\e[2J"
  end
end
