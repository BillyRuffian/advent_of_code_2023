

def part1

  lines = File.readlines('input.txt', chomp: true)
  number_loc = {}
  symbol_loc = {}

  lines.each_with_index do |line, line_idx|
    number_loc.merge! line.enum_for(:scan, /([0-9]+)/).map { [[line_idx, Regexp.last_match.begin(0)], Regexp.last_match[1]] }.to_h
    symbol_loc.merge! line.enum_for(:scan, /([^0-9\.]+)/).map { [[line_idx, Regexp.last_match.begin(0)], Regexp.last_match[1]] }.to_h
  end

  pp number_loc.map { |location, number|
    line, col = location 
    length = number.chars.count

    match = catch(:match) {
      (line-1..line+1).each { |search_line|
        (col-1..col+length).each { |search_col|
          throw :match, number.to_i if symbol_loc[[search_line, search_col]]
        }
      }
      throw :match, nil
    }

  match
  }.compact.sum
end

part1