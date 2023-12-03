def part1
  lines = File.readlines('input.txt', chomp: true)

  pp lines.map { |line|
    line.chars
        .select { ('0'..'9').include? _1 }
        .then {  "#{_1.first}#{_1.last}".to_i }

  }.sum
end


def part2
  lines = File.readlines('input.txt', chomp: true)

  word_values = {
    'one'   => '1',
    'two'   => '2',
    'three' => '3',
    'four'  => '4',
    'five'  => '5',
    'six'   => '6',
    'seven' => '7',
    'eight' => '8',
    'nine'  => '9'
  }

  re = %r{(?=(#{word_values.keys.join('|')}|\d))}

  pp lines.map { |line|
    # pp line
    line
        .scan(re)
        .flatten
        .map { word_values[_1] || _1 }
        .then {  "#{_1.first}#{_1.last}" }
        .to_i
  }.sum
end


part1
part2