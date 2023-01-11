require 'byebug'

class Card
  include Comparable
  attr_reader :rank, :suit

  VALUES = { 'Jack' => 11, 'Queen' => 12, 'King' => 13, 'Ace' => 14 }
  SUITS = { 'Spades' => 4, 'Hearts' => 3, 'Clubs' => 2, 'Diamonds' => 1}

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def value
    VALUES.fetch(rank, rank)
  end

  def suit_value
    SUITS.fetch(suit)
  end

  def <=>(other_card)
    if value == other_card.value
      suit_value <=> other_card.suit_value
    else
      value <=> other_card.value    
    end
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  attr_accessor :cards

  def draw
    reset if cards.empty?
    cards.pop
  end

  def initialize
    reset
  end

  def generate_cards
    @cards = []
    SUITS.each do |s|
      RANKS.each do |r|
        cards << Card.new(r, s)
      end
    end
  end

  def shuffle!
    temp = []
    cards.size.times { temp << cards.delete(cards.sample) }
    self.cards = temp
  end

  def reset
    generate_cards
    shuffle!
  end
end

class PokerHand
  FLUSH_RANKS = [10, 'Jack', 'Queen', 'King', 'Ace']
  attr_accessor :hand, :deck
  def initialize(deck)
    @deck = deck
    @hand = []
    fill_hand
  end

  def fill_hand
    5.times { |_| hand << deck.draw }
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  def ranks
    hand.map { |c| c.rank }
  end

  def suits
    hand.map { |c| c.suit }
  end

  def values
    hand.map { |c| c.value }
  end

  def rank_occurences
    occurrences = Hash.new(0)
    ranks.each { |r| occurrences[r] += 1 }
    occurrences
  end

  def straight_range
    low, high = values.minmax
    # allow aces to count low as well as high
    low = 1 if ranks.include?('Ace') && ranks.include?(2)
    (low..high).to_a
  end

  private

  def of_a_kind(blank, quantity)
    rank_occurences.select { |_, v| v == blank }
    .size == quantity
  end

  def royal_flush?
    straight_range == [10,11,12,13,14] &&
    flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    of_a_kind(4, 1)
  end

  def full_house?
    rank_occurences.select { |_, v| v == 3 }
    .size == 1 &&
    rank_occurences.select { |_, v| v == 2 }
    .size == 1
  end

  def flush?
    suits.uniq.size == 1 
  end

  def straight?
    values.sort == straight_range
  end

  def three_of_a_kind?
    of_a_kind(3, 1)
  end

  def two_pair?
    of_a_kind(2, 2)
  end

  def pair?
    of_a_kind(2, 1)
  end
end



# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate #== 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate #== 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate #== 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'