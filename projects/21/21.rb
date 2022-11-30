module Hand
  attr_accessor :hand

  def bust?
    score_hand > 21
  end

  def make_stay
    self.stay = true
  end

  def stay?
    stay
  end

  def hit(deck)
    hand << deck.deal
  end

  def display_hand
    hand.each { |card| puts "  #{card}" }
    puts "  (#{score_hand} points)"
  end

  def score_card(card, total)
    case card.value
    when Integer then card.value
    when 'Ace' then total + 11 > 21 ? 1 : 11
    else 10
    end
  end

  # aces are scored last to prevent them accidentally being scored as 11
  # and causing bust? to trigger
  def score_hand
    total = 0
    aces, other_cards = hand.partition do |card|
      card.value == 'Ace'
    end
    other_cards.each { |c| total += score_card(c, total) }
    aces.each { |c| total += score_card(c, total) }
    total
  end
end

class Dealer
  attr_accessor :stay

  include Hand
  def initialize
    @stay = false
    self.hand = []
  end
end

class Player < Dealer
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
  RESULT_MESSAGES = { player: 'congratulations, you win!',
                      dealer: 'the dealer wins. better luck next time!',
                      tie: 'you tied!' }
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

  def clear_screen
    system('clear')
  end

  def display_welcome_message
    clear_screen
    puts "lets play some 21!\n\n"
    puts "enter 'r' for the rules or anything else to continue"
    ans = gets.chomp.downcase
    display_rules if ans == 'r'
    puts
  end

  def turns
    [player, dealer].each do |person|
      loop do
        break if player.bust?
        person == player ? player_turn : dealer_turn
        break if person.bust? || person.stay?
      end
    end
  end

  def main_game
    loop do
      deal_starting_hands
      turns
      display_winner
      break if quit?
      reset
    end
  end

  def deal_starting_hands
    [player, dealer].each do |person|
      2.times { person.hit(deck) }
    end
  end

  def player_turn
    display_hands_and_total
    ans = choose_to_hit_or_stay
    if ans == 'h'
      player.hit(deck)
      display_hit
    else
      player.make_stay
      puts 'you stay'
    end
  end

  def choose_to_hit_or_stay
    puts
    ans = nil
    loop do
      puts "will you hit or stay? (h / s)"
      ans = gets.chomp.downcase
      break ans if %w(h s).include?(ans)
    end
  end

  def display_hit
    puts 'you hit!'
    puts "you drew a #{player.hand[-1]} "\
         "and your new score is #{player.score_hand}"
    puts "you bust!" if player.bust?
    puts 'press enter to continue'
    gets
  end

  def dealer_turn
    display_dealer_hand
    until dealer.score_hand >= 17
      dealer_hit
    end
    dealer.make_stay if dealer.score_hand <= 21
    return unless dealer.stay?
    puts "the dealer stays"
    puts "press enter to continue"
    gets
  end

  def dealer_hit
    puts "the dealer hits!"
    dealer.hit(deck)
    puts "it's a #{dealer.hand[-1]}!"
    puts "dealer's new hand value: #{dealer.score_hand}"
    puts "the dealer bust!" if dealer.bust?
    puts "press enter to continue"
    gets
    display_dealer_hand
  end

  def display_dealer_hand
    clear_screen
    puts "dealer hand:"
    dealer.display_hand
    puts
  end

  def quit?
    puts
    puts "do you want to quit?"
    puts "input 'q' to quit or anything else to play again"
    ans = gets.chomp.downcase
    ans == 'q'
  end

  def reset
    [player, dealer].each { |p| p.hand = [] }
    self.deck = Deck.new
  end

  def display_hands_and_total
    clear_screen
    puts "dealer's hand:"
    puts "  #{dealer.hand.sample}\n  unknown card\n\n"
    puts "your hand:"
    player.display_hand
    puts
  end

  def display_winner
    clear_screen
    puts RESULT_MESSAGES[determine_results]
    puts "final hands:\n\n"
    puts "dealer:"
    dealer.display_hand
    puts
    puts "you:"
    player.display_hand
  end

  def determine_results
    return :dealer if player.bust?
    return :player if dealer.bust?
    player_score = player.score_hand
    dealer_score = dealer.score_hand
    return :player if player_score > dealer_score
    return :dealer if dealer_score > player_score
    :tie
  end

  def display_goodbye_message
    puts
    puts "thanks for playing!"
  end

  def display_rules
    rules = <<~MSG
try to get a higher score than the dealer without going over 21.
you can either "hit" to get another card or "stay" to compete with your current cards.
a score over 21 means you "bust" (lose).
the dealer must hit until their score is 17 or more.
aces are worth 11 unless they would cause you to bust; in this case, they are worth 1.
press enter to continue
MSG
    puts rules
    gets
  end
end

TwentyOneGame.new.play
Player.ancestors
