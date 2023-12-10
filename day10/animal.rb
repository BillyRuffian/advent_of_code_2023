require 'pry'

class Map 
  include Enumerable
  attr_reader :grid, :start_x, :start_y

  def initialize
    @grid = File.readlines('input.txt', chomp: true).map(&:chars)

    @start_y = grid.index(grid.find { |y| y.include?('S') })
    @start_x = grid[start_y].index('S')
  end

  def each
    loc_x = start_x
    loc_y = start_y
    history = {}

    direction = nil

    loop do
      current = history[[loc_y, loc_x]] = grid[loc_y][loc_x]
      yield([loc_y, loc_x])
      allowed_locations = candidates(loc_y, loc_x).reject { |coord| !history[coord].nil? } # filter if we been here before

      # puts "At #{loc_x}, #{loc_y} seeing #{current}"
      # puts "Can move to one of #{allowed_locations}"

      allowed_locations.filter! do |(y, x)|
        dest_node = grid[y][x]
        dir = direction_finder(loc_y, loc_x, y, x)
        # valid = allowed_connectors.include?(dest_node)
        valid = connectable?(current, dest_node, dir)
        # puts "  #{x}, #{y} has a #{dest_node} - this is #{valid ? 'TICK' : 'invalid'}"
        valid
      end

      if allowed_locations.empty?
        # puts 'arrived'
        break
      end

      chose_y, chose_x = allowed_locations.first 
      direction = direction_finder(loc_y, loc_x, chose_y, chose_x)

      # puts "So limited to  #{allowed_locations} and picked #{chose_y}, #{chose_x} and going #{direction}"

      # gets

      loc_y, loc_x = chose_y, chose_x
    end
  end

  def candidates(loc_y, loc_x)
    [[loc_y - 1, loc_x], [loc_y, loc_x - 1], [loc_y, loc_x + 1],[loc_y + 1, loc_x]]
      .filter { |coord| coord.all? {|c| c >= 0 } }
      .filter { |y, x| y < grid.count && x < grid.first.count }
  end

  def connectable?(node, candidate, direction)
    case [node, direction]
    in %w[| N]
      %w[| 7 F S].include?(candidate)
    in %w[| S]
      %w[| J L S].include?(candidate)

    in %w[- E]
      %w[- 7 J S].include?(candidate)
    in %w[- W]
      %w[- F L S].include?(candidate)

    in %w[L E]
      %w[- J S 7].include?(candidate)
    in %w[L N]
      %w[| 7 F S].include?(candidate)

    in %w[J W]
      %w[- L F S].include?(candidate)
    in %w[J N]
      %w[| F 7 S].include?(candidate)

    in %w[F E]
      %w[- 7 J S].include?(candidate)
    in %w[F S]
      %w[| L J S].include?(candidate)

    in %w[7 W]
      %w[- L S F].include?(candidate)
    in %w[7 S]
      %w[| J L S].include?(candidate)
    
    in %w[S N]
      %w[| 7 F].include?(candidate)
    in %w[S E]
      %w[- 7 J].include?(candidate)
    in %w[S S]
      %w[| J L].include?(candidate)
    in %w[S W]
      %w[- F L].include?(candidate)

    else
      false

    end
  end

  def direction_finder( y1, x1, y2, x2)
    case [y1 - y2, x1 -x2]
    when [-1, 0]
      'S'
    when [1, 0]
      'N'
    when [0, -1]
      'E'
    when [0, 1]
      'W'
    end
  end
end

# part 1
puzzle = Map.new
path = puzzle.map { |node| node }
pp path.count / 2

# part 2
# surrender -- part 2 is very incomplete. Too much time spent, abort abort
path.each { |(y,x)| puzzle.grid[y][x] = '#' }
puzzle.grid.each_with_index do |row, y| 
  row.each_with_index do |cell, x|
    puzzle.grid[y][x] = ' ' unless ['#', '.'].include?(cell)
  end
end

puzzle.grid.each { |row| puts row.join}