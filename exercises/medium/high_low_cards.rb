class Card
include Comparable
  attr_reader :value, :suit
  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value} of #{suit}"
  end


  def order
    case self.value
    when Integer then value
    when 'Jack' then 11
    when 'Queen' then 12
    when 'King' then 13
    when 'Ace' then 14
    end
  end

  def rank
    value
  end

  def <=>(other)
    self.order <=> other.order
  end
end

cards = [Card.new(2, 'Hearts'),
Card.new(10, 'Diamonds'),
Card.new('Ace', 'Clubs')]
puts cards
puts cards.min == Card.new(2, 'Hearts')
puts cards.max == Card.new('Ace', 'Clubs')

cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
Card.new(4, 'Diamonds'),
Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
Card.new('Jack', 'Diamonds'),
Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
Card.new(8, 'Clubs'),
Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8