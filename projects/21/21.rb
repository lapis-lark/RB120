require 'byebug'

module Hand
  attr_accessor :hand
  @hand = []

  def bust?

  end

  def hit

  end

  def stay

  end
end

class Player
include Hand
def initialize
  self.hand = []
end

def total
  values = hand.inject([]) { |memo, card| memo + [card.value]}
  values.map { |v| v.class == String ? 10 : v }
end
end

class Dealer
include Hand
def initialize
  self.hand = []
end
end

class Deck
  attr_accessor :cards
  SUITS = %w(Spades Hearts Clubs Diamonds)
  VALUES = ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']
  def initialize
    @cards = []
    SUITS.each do |s|
      VALUES.each { |v| cards << Card.new(s, v) }
    end
  end

  def deal
    card = cards.sample
    cards.delete(card)
  end
end

class Card
  attr_reader :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "#{value} of #{suit}"
  end
end

class TwentyOneGame
  attr_accessor :player, :dealer, :deck
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @player_stay = false
    @dealer_stay = false
  end

  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private
  def display_welcome_message
    puts "lets play some 21!"
  end
  def main_game
    loop do
      deal_starting_hands
      loop do
        player_turn
        break if player.bust? || player.stay?
      end
      loop do
        dealer_turn
        break if dealer.bust? || dealer.stay?
      end
      display_winner
    end
  end

  def deal_starting_hands
    byebug
    [player, dealer].each do |person|
      2.times { person.hand << deck.deal}
    end
  end

  def player_turn
    puts "will you hit or stay?"
  end

  def display_hand_and_total
    puts "your cards:\n#{player.cards.join("\n")}"
    puts "(#{player.total} points total)"
  end
end

TwentyOneGame.new.play