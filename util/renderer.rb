class Renderer
  require 'colorize'

  def initialize(brain)
    @brain = brain
  end

  def world(world)
    tiles = @brain.map.tiles
    flags = @brain.map.flags
    colors = @brain.map.colors
    size = @brain.map.size + 1
    players = world.players
    buffer = ""

    if tiles
      # Header
      buffer << "".ljust(3)
      size.times do |x|
        x = x
        buffer << x.to_s.ljust(3)
      end
      buffer << "\n"

      # Down
      size.times do |y|
        y = y
        buffer << y.to_s.ljust(3)

        size.times do |x|
          x = x
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

          # Is it another player?
          players.each do |p|
            if p == tile
              char = '^'
            end
          end

          # Pad it out
          char = (char || "").ljust(3)

          # Should I color the tile?
          color = (colors[x] || [])[y]
          if color
            char = if color.to_sym == :black
              char.colorize(:black).on_white
            else
              char.colorize(color.to_sym)
            end
          end

          buffer << char
        end

        buffer << "\n"
      end

      buffer << "\n"
    end

    buffer
  end
end
