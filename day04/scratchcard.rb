
def part1
  lines = File.readlines('input.txt', chomp: true)

  re = /Card\s+(?:\d+):(?<wins>.*)\|(?<plays>.*)/

  result = lines.map do |card|
    md = card.match(re)
    wins = md[:wins].split.map(&:to_i)
    plays = md[:plays].split.map(&:to_i)

    number_of_matches = wins.intersection(plays).count
    if number_of_matches > 0
      2 ** (number_of_matches-1)
    else
      0
    end

  end

  pp result.sum
end


def part2
  lines = File.readlines('input.txt', chomp: true)

  re = /Card\s+(?<card_number>\d+):(?<wins>.*)\|(?<plays>.*)/

  cards = lines.map do |card|
    md = card.match(re)
    card_number = md[:card_number].to_i
    wins = md[:wins].split.map(&:to_i)
    plays = md[:plays].split.map(&:to_i)

    [card_number, {winning_numbers: wins, play_numbers: plays, count: 1}]
  end.to_h

  cards.each do |card, data|
    data => {winning_numbers:, play_numbers:, count:}

    wins_this_card = winning_numbers.intersection(play_numbers).count
    next if wins_this_card == 0

    (1..wins_this_card).each do |offset|
      cards[card+offset][:count] = cards[card+offset][:count] + count
    end
  end

  pp cards.to_h.values.map { _1[:count] }.sum
end


part2