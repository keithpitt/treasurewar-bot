require_relative './area'

class PathFinder
  def initialize(brain, options = {})
    @brain = brain
    @destination = options[:point]

    @known = []
  end

  def decide_action(world)
    all_paths = []
    traverse all_paths, nil, world.you.position

    # Find the shortest distance of the all
    lowest_distance_path = [ 0, nil ]

    all_paths.each do |x|
      path = x.dup
      distance = 0

      while current = path.shift
        next_one = path.first
        if next_one
          distance += current.distance_to(next_one)
        end
      end

      if lowest_distance_path[0] == 0 || distance < lowest_distance_path[0]
        lowest_distance_path = [ distance, x ]
      end
    end

    lowest_distance_path[1].each do |point|
      @brain.map.flag point, '~'
    end

    @brain.map.flag @destination, '!'

    # Got to position
    # @brain.finished_priority
  end

  def traverse(all_paths, current_path, start)
    scope = Square.new(start.x, start.y, start.x, start.y)
    scope.pad(1)

    # Find out all possbile walking points from this point
    area = Area.new(@brain.map, scope)
    walkable_points = area.walkable_points

    # Have we gone there before?
    if current_path
      walkable_points = walkable_points.reject do |point|
        current_path.include? point
      end
    end

    if current_path == nil
      main_paths = []
    end

    walkable_points.each do |point|
      path = if current_path
               current_path << point
             else
               x = [ point ]
               all_paths << x
               x
             end

      unless point == @destination
        traverse all_paths, path, point
      end
    end

    if current_path == nil
      main_paths
    else
      current_path
    end
  end
end
