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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.