require 'pry'

# Part 1

class Hand
  HAND_TYPES = {
    five_of_a_kind: 7,
    four_of_a_kind: 6,
    full_house: 5,
    three_of_a_kind: 4,
    two_pair: 3,
    one_pair: 2,
    high_card: 1
  }

  CARD_TYPES = %w[ 2 3 4 5 6 7 8 9 T J Q K A].map.with_index { |v, i| [v, i+1] }.to_h

  attr_accessor :cards, :bid

  def initialize(cards, bid)
    @cards = cards.chars
    @bid = bid.to_i
  end

  def kind
    case cards.tally.values.sort
    in [5]
      :five_of_a_kind
    in [1, 4]
      :four_of_a_kind
    in [2, 3]
      :full_house
    in [1, 1, 3]
      :three_of_a_kind
    in [1, 2, 2]
      :two_pair
    in [1, 1, 1, 2]
      :one_pair
    in [1, 1, 1, 1, 1]
      :high_card
    else
      raise "Dunno #{cards}"
    end
  end

  def card_types
    CARD_TYPES
  end

  def card_scores
    cards.map { |c| card_types[c] }
  end

  def <=>(other)
    comparison = HAND_TYPES[kind] <=> HAND_TYPES[other.kind]
    return comparison unless comparison == 0

    pairs = card_scores.zip(other.card_scores)
    first_difference = pairs.find { |(this, that)| this != that }

    first_difference.first <=> first_difference.last
  end
end

hands = File.readlines('input.txt', chomp: true).map { |l| l.split.then { |v| Hand.new(*v) } }
score = hands.sort.map.with_index { |h, idx| h.bid * (idx+1) }

pp score.sum

# Part 2

class JokerHand < Hand 
  CARD_TYPES = %w[ J 2 3 4 5 6 7 8 9 T Q K A].map.with_index { |v, i| [v, i+1] }.to_h

  def card_types
    CARD_TYPES
  end

  def kind
    tally = cards.tally
    if tally.size > 1
      jokers = tally.delete('J') 
      key = tally.sort_by { |_k, v| v }.reverse.to_h.keys.first
      tally[key] = tally[key] + jokers if jokers
    end

    # binding.pry 
    case tally.values.sort
    in [5]
      :five_of_a_kind
    in [1, 4]
      :four_of_a_kind
    in [2, 3]
      :full_house
    in [1, 1, 3]
      :three_of_a_kind
    in [1, 2, 2]
      :two_pair
    in [1, 1, 1, 2]
      :one_pair
    in [1, 1, 1, 1, 1]
      :high_card
    else
      raise "Dunno #{cards}"
    end
  end
end

hands = File.readlines('input.txt', chomp: true).map { |l| l.split.then { |v| JokerHand.new(*v) } }
score = hands.sort.map.with_index { |h, idx| h.bid * (idx+1) }

pp score.sum

# pp hands.map { [_1.cards.join, _1.kind] }
