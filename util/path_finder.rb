require_relative './area'

class PathFinder
  class PointMoved < SimpleDelegator
    attr_accessor :parent
    attr_accessor :g_cost

    def initialize(object, g_cost, parent)
      super(object)
      @g_cost = g_cost
      @parent = parent
    end
  end

  def initialize(brain, options = {})
    @brain = brain
    @destination = options[:point]

    @known = []
  end

  def decide_action(world)
    @chosen_path ||= find_path(world)

    if @chosen_path.length == 0
      @brain.finished_priority
    else
      return 'move', :dir => @chosen_path.shift
    end
  end

  def find_path(world)
    starting_point = world.you.position
    closed_list = []
    open_list = [ PointMoved.new(starting_point, nil, nil) ]
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

      # p [ current_point, lowest_f_cost, lowest_h_cost, lowest_g_cost ]

      current_point = PointMoved.new(current_point, lowest_g_cost, parent_point)

      # Drop it from the open list and add it to the closed list
      open_list.delete(current_point)
      closed_list << current_point

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
          adjacent_g_cost = calculate_g_cost parent_point || current_point, point
          point_with_parent = PointMoved.new(point, adjacent_g_cost, current_point)

          if open_list.include?(point)
            if adjacent_g_cost < lowest_g_cost
              point_with_parent.parent = point
            end
          else
            point_with_parent.parent = current_point
          end

          if point_with_parent == @destination
            found_destination = point_with_parent
            break
          end

          open_list << point_with_parent
        end
      end

      break if found_destination

      parent_point = current_point
    end

    path = []
    parent = found_destination
    while parent.parent != nil
      path << parent
      parent = parent.parent
    end
    path << starting_point

    directions = []
    for i in 0..path.length
      point_after = path[i + 1]
      if point_after
        directions << point_after.direction_from(path[i])
      end
    end

    # Try and cut corners
    optimized_path = []

    i = 0
    while i < directions.length
      # Can we skip to the next one?
      main = directions[i]
      after = directions[i + 1]

      skipped = "#{main}#{after}"

      if skipped == "ne" || skipped == "nw" || skipped == "se" || skipped == "sw"
        optimized_path << skipped.to_sym
        i = i + 2
      else
        optimized_path << main
        i = i + 1
      end
    end

    optimized_path
  end

  def walkable_points_from(point)
    scope = Square.new(point.x, point.y, point.x, point.y)
    scope.pad(1)

    Area.new(@brain.map, scope).walkable_points
  end

  def calculate_g_cost(starting_point, current_point)
    base = if starting_point
             starting_point.g_cost
           else
             0
           end

    direction = current_point.direction_from(starting_point).to_s

    base + if direction.length == 2
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
