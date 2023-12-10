require 'pry'

class Map 
  include Enumerable
  attr_reader :map, :start_x, :start_y

  def initialize
    @map = File.readlines('input.txt', chomp: true).map(&:chars)

    @start_y = map.index(map.find { |y| y.include?('S') })
    @start_x = map[start_y].index('S')
  end

  def each
    loc_x = start_x
    loc_y = start_y
    history = {}

    direction = nil

    loop do
      current = history[[loc_y, loc_x]] = map[loc_y][loc_x]
      allowed_locations = candidates(loc_y, loc_x).reject { |coord| !history[coord].nil? } # filter if we been here before
      allowed_connectors = connectables(current, direction)

      puts "At #{loc_x}, #{loc_y} seeing #{current}"
      puts "Can move to one of #{allowed_locations}"
      puts "Can go to any of the connectors #{allowed_connectors}"

      allowed_locations.filter! do |(y, x)|
        dest_node = map[y][x]
        valid = allowed_connectors.include?(dest_node)
        puts "  #{x}, #{y} has a #{dest_node} - this is #{valid ? 'TICK' : 'invalid'}"
        valid
      end

      if allowed_locations.empty?
        puts 'arrived'
        break
      end

      chose_y, chose_x = allowed_locations.first 
      direction = direction_finder(loc_y, loc_x, chose_y, chose_x)

      puts "So limited to  #{allowed_locations} and picked #{chose_y}, #{chose_x} and going #{direction}"

      gets

      loc_y, loc_x = chose_y, chose_x
    end
  end

  def candidates(loc_y, loc_x)
    [[loc_y - 1, loc_x], [loc_y, loc_x - 1], [loc_y, loc_x + 1],[loc_y + 1, loc_x]]
      .filter { |coord| coord.all? {|c| c >= 0 } }
      .filter { |y, x| y < map.count && x < map.first.count }
  end

  def connectables(node, direction)
    case [node, direction]
    in %w[ | N ]
      %w[ | F 7 S ]
    in %w[ | S ]
      %w[ | J L S ]

    in %w[ - E ]
      %w[ - J 7 S ]
    in %w[ - W ]
      %w[ - L F S ]

    in %w[ L S ]
      %w[ - 7 J S ]
    in %w[ L W ]
      %w[ | 7 F S]

    in %w[ J S ]
      %w[ - L F S ]
    in %w[ J E ]
      %w[ | F 7 S ]

    in %w[ F W ]
      %w[ | J L S ]
    in %w[ F N ]
      %w[ - 7 J S]

    in %w[ 7 E ]
      %w[ | J L S ]
    in %w[ 7 N ]
      %w[ - F L S ]

    in ['S', _]
      %w[ - | L J F ]
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

map = Map.new.each { puts x }