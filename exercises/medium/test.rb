class Card
  include Comparable
  attr_reader :rank, :suit
  VALUES = { 'Jack' => 11, 'Queen' => 12,  'King' => 13, 'Ace' => 14 }
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def value
    VALUES.fetch(rank,rank)
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze


  def initialize
    @deck = reset
  end

  def draw
    draw = deck.pop
    deck.empty? ?  reset : draw
    Card.new(draw[0], draw[1])
  end

  private
  attr_reader :deck

  def reset
    @deck = RANKS.product(SUITS).shuffle
  end
end

class PokerHand
  def initialize(deck)
    @hand = []
    5.times {@hand << deck.draw}
  end

  def print
    hand.each {|card| puts card.to_s}
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then  'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                        'High card'
    end
  end

  private
  attr_accessor :hand
  ROYAL_FLUSH = [10, 11, 12, 13, 14]

  def rank_count(hand, n)
    ranks = hand.map(&:value)
    ranks.select {|rank| ranks.count(rank) == n}.uniq.size == 1
  end

  def royal_flush?
    straight_flush? && hand.all? {|card| ROYAL_FLUSH.include?(card.value)}
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    rank_count(hand,4)
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    first_suit = hand[0].suit
    hand.all? {|card| card.suit == first_suit}
  end

  def straight?
    min_card = hand.min.value
    max_card = hand.max.value
    range = (min_card..max_card).to_a
    ranks = hand.map(&:value)
    ranks.sort == range
  end

  def three_of_a_kind?
    rank_count(hand,3)
  end

  def two_pair?
    ranks = hand.map(&:value)
    pairs = ranks.select {|rank| ranks.count(rank) == 2}
    pairs.size == 4
  end

  def pair?
    rank_count(hand,2)
  end
end

class Array
  alias_method :draw, :pop
end

# Test 

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