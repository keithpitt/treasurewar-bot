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

          char = if tile
                   type = tile.type
                   if type == 'floor'
                     "."
                   elsif type == 'stash'
                     "$"
                   elsif type == 'item'
                     "#"
                   elsif type == 'wall' || type == 'space'
                     "W"
                   end
                 end

          # Is it a flag?
          flag = (flags[x] || [])[y]
          char = flag.char if flag

          # Is it the player
          char = '@' if tile == @brain.player.position

          buffer << (char || "").ljust(3)
        end

        buffer << "\n"
      end

      buffer << "\n"
    end

    buffer
  end
end
