require 'byebug'

module Hand
  attr_accessor :hand

  def bust?
    self.score_hand > 21
  end

  def make_stay
    self.stay = true
  end

  def stay?
    self.stay
  end

  def score_card(card, total)
    case card.value
    when Integer then card.value
    when 'Ace' then total + 11 > 21 ? 1 : 11
    else 10
    end
  end

  def score_hand
    total = 0
    # aces are scored last to prevent them accidentally being scored as 11
    # and causing bust? to trigger
    number_cards, face_cards = hand.partition do |card|
      card.value.instance_of?(Integer)
    end
    number_cards.each { |c| total += score_card(c, total) }
    face_cards.sort! { |a, b| b.value <=> a.value }
    face_cards.each { |c| total += score_card(c, total) }
    total
  end
end

class Dealer
  include Hand
  def initialize
    self.hand = []
  end
end

class Player < Dealer
  attr_accessor :stay
def initialize
    @stay = false
    super
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
  end

  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "lets play some 21!\n\n"
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
    [player, dealer].each do |person|
      2.times { person.hand << deck.deal }
    end
  end

  def player_turn
    display_hand_and_total
    puts
    ans = nil
    loop do
      puts "will you hit or stay? (h / s)"
      ans = gets.chomp.downcase
      break if %w(h s).include?(ans)
    end
    if ans == 'h'
      puts 'you hit!'
      player_hit
    else
      puts 'you stay'
      player.make_stay
    end
  end

  def player_hit
    player.hand << deck.deal
  end

  def dealer_hit
    dealer.hand << deck.deal
  end

  def display_hand_and_total
    puts "your cards (#{player.score_hand} points):"
    player.hand.each { |card| puts card }
  end
end

 TwentyOneGame.new.play
 Player.ancestors
