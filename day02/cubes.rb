require 'pry'


MAXIMUMS = {
  red: 12,
  green: 13,
  blue: 14
}


def part1
  lines = File.readlines('input.txt', chomp: true)

  re = /Game (?<game_number>\d+): (?<turns>.*)/

  pp lines.map { |line| 
    md = line.match(re)
    game_number = md[:game_number].to_i
    turns = md[:turns]
    turn_max = %i[red green blue].map { |col| [col, turns.scan(/(\d+) #{col}/).flatten.map(&:to_i).max || 0] }.to_h
    if turn_max.all? { |col, max| max <= MAXIMUMS[col] }
      game_number
    else
      nil
    end
  }.compact.sum
end


def part2
  lines = File.readlines('input.txt', chomp: true)

  re = /Game (?<game_number>\d+): (?<turns>.*)/

  pp lines.map { |line| 
    md = line.match(re)
    game_number = md[:game_number].to_i
    turns = md[:turns]
    turn_max = %i[red green blue].map { |col| [col, turns.scan(/(\d+) #{col}/).flatten.map(&:to_i).max || 0] }.to_h
    turn_max.values.inject(:*)
}.sum
end

part2