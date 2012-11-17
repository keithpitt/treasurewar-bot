require_relative './area'

class PathFinder
  class PointWithParent < SimpleDelegator
    attr_accessor :parent

    def initialize(object, parent)
      super(object)
      @parent = parent
    end
  end

  def initialize(brain, options = {})
    @brain = brain
    @destination = options[:point]

    @known = []
  end

  def decide_action(world)
    starting_point = world.you.position
    closed_list = []
    open_list = [ PointWithParent.new(starting_point, nil) ]
    parent_point = nil

    found_destination = nil

    while !open_list.empty?
      current_point = nil
      lowest_f_cost = nil
      lowest_h_cost = nil
      lowest_g_cost = nil

      # Look for the lowest F cost square on the open list. We refer to this as the current square
      if open_list.length == 1
        x = open_list.first
        current_point = x
        lowest_f_cost = 0
        lowest_h_cost = 0
        lowest_g_cost = 0
      else
        open_list.each do |point|
          # G = the movement cost to move from the starting point A to a given square on the grid, following the path generated to get there.
          g_cost = calculate_g_cost parent_point, point

          # H = the estimated movement cost to move from that given square on the grid to the final destination, point B.
          # This is often referred to as the heuristic, which can be a bit confusing. The reason why it is called that is because it is a guess.
          # We really don’t know the actual distance until we find the path, because all sorts of things can be in the way (walls, water, etc.).
          h_cost = calculate_h_cost point, @destination

          # F = G + H
          f_cost = g_cost + h_cost

          if current_point == nil || f_cost < lowest_f_cost
            current_point = point
            lowest_f_cost = f_cost
            lowest_h_cost = h_cost
            lowest_g_cost = g_cost
          end
        end
      end

      p [ current_point, lowest_f_cost, lowest_h_cost, lowest_g_cost ]

      current_point = PointWithParent.new(current_point, parent_point)

      # Drop it from the open list and add it to the closed list
      open_list.delete(current_point)
      closed_list << current_point

      if current_point == @destination
        p 'found it!'
        found_destination = current_point
        break
      end

      # Check all of the adjacent squares. Ignoring those that are on the closed list or unwalkable (terrain with walls, water, or other illegal terrain),
      # add squares to the open list if they are not on the open list already. Make the selected square the "parent" of the new squares
      #
      # If an adjacent square is already on the open list, check to see if this path to that square is a better one.
      # In other words, check to see if the G score for that square is lower if we use the current square to get there. If not, don’t do anything. 
      # On the other hand, if the G cost of the new path is lower, change the parent of the adjacent square to the selected square
      # (in the diagram above, change the direction of the pointer to point at the selected square). Finally, recalculate both the F and G
      # scores of that square. If this seems confusing, you will see it illustrated below.
      walkable_points_from(current_point).each do |point|
        # Do nothing if already on the closed list
        unless closed_list.include?(point)
          point_with_parent = PointWithParent.new(point, current_point)

          if open_list.include?(point) && parent_point
            adjacent_g_cost = calculate_g_cost parent_point, point

            if adjacent_g_cost < lowest_g_cost
              point_with_parent.parent = point
            end
          else
            point_with_parent.parent = current_point
          end

          open_list << point_with_parent
        end
      end

      parent_point = current_point
    end

    path = []
    parent = found_destination
    while parent.parent != nil
      path << parent
      parent = parent.parent
    end

    path.each do |point|
      @brain.map.flag point, '~'
    end

    @brain.map.flag @destination, '!'
  end

  def walkable_points_from(point)
    scope = Square.new(point.x, point.y, point.x, point.y)
    scope.pad(1)

    Area.new(@brain.map, scope).walkable_points
  end

  def calculate_g_cost(starting_point, current_point)
    direction = current_point.direction_from(starting_point).to_s

    if direction.length == 2
      14
    else
      10
    end
  end

  def calculate_h_cost(starting_point, finishing_point)
    vertical = (starting_point.x - finishing_point.x).abs
    if vertical % 3 == 0
      vertical += 1
    else
      vertical
    end

    horizontal = (starting_point.y - finishing_point.y).abs
    if horizontal % 3 == 0
      horizontal += 1
    else
      horizontal
    end

    vertical + horizontal
  end
end
