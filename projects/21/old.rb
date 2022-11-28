require 'byebug'
MAXIMUM = 21
MAX_WINS = 5
DEALER_STAYS = 17

INTRODUCTION = <<~MSG
welcome to #{MAXIMUM}!#{' '}
try to get a higher score than the dealer without going over #{MAXIMUM}.
you can either "hit" to get another card or "stay" to compete with your current cards.
a score over #{MAXIMUM} means you "bust" (lose).
the dealer must hit until their score is at least #{DEALER_STAYS}.
aces are worth 11 if your score is 10 or less, otherwise just 1.
try to beat the dealer to #{MAX_WINS} wins!
MSG

hands = { player: [], dealer: [] }

# deck structure based on the small problems debugging problem "Card Deck"
cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]

deck = { hearts: cards.clone,
         diamonds: cards.clone,
         clubs: cards.clone,
         spades: cards.clone }

def clear_screen
  system('clear')
end

def prompt(str)
  puts "~~> #{str}"
end

def proper_card_name(card)
  "#{card[:value].to_s.capitalize} of #{card[:suit].capitalize}"
end

def format_cards(arr)
  arr = arr.map { |card| proper_card_name(card) }

  case arr.size
  when 1 then arr[0]
  when 2 then "#{arr[0]} and #{arr[1]}" if arr.size == 2
  else "#{arr[0...-1].join(', ')} and #{arr[-1]}"
  end
end

def score(card, num)
  case card[:value]
  when Integer then card[:value]
  when :ace then (num > 10 ? 1 : 11)
  else 10
  end
end

def score_hand(hand)
  num = 0
  hand.each { |card| num += score(card, num) }
  num
end

def deal_card(deck, hand)
  suit = deck.keys.sample
  value = (deck[suit].delete(deck[suit].sample))
  hand << { value: value, suit: suit }
  { value: value, suit: suit }
end

def deal_hands(deck, hands)
  2.times do
    deal_card(deck, hands[:player])
    deal_card(deck, hands[:dealer])
  end
end

def bust?(num)
  num > MAXIMUM
end

def display_winner(winner, hands, total)
  puts "=================================="
  prompt("your hand: #{format_cards(hands[:player])} \
(#{total[:player]})")

  prompt("dealer's hand: #{format_cards(hands[:dealer])} \
(#{total[:dealer]})")
  puts "=================================="

  case winner
  when 'dealer' then prompt('you lost the round!')
  when 'player' then prompt('you won the round!')
  when 'draw' then prompt("it's a tie!")
  end
end

def player_turn_messages(hands, total)
  prompt("dealer's hand: #{format_cards([hands[:dealer][0]])} \
and an unknown card")

  prompt("your hand: #{format_cards(hands[:player])} \
(#{total[:player]})")
end

def valid_move
  loop do
    ans = gets.chomp.downcase
    break ans if %w(h s).include?(ans)
    prompt('please input either "h" for hit or "s" for stay')
  end
end

def hit(hitter, deck, hands, total)
  card = deal_card(deck, hands[hitter])
  total[hitter] += score(hands[hitter][-1], total[hitter])
  card
end

def player_turn(deck, hands, total)
  player_turn_messages(hands, total)
  loop do
    prompt("will you (h)it or (s)tay?")
    case valid_move
    when 'h'
      card = hit(:player, deck, hands, total)
      prompt("you drew a #{format_cards([card])}")
      prompt("your hand is now: #{format_cards(hands[:player])} \
(#{total[:player]})")
    when 's'
      break prompt("you stay at #{total[:player]}")
    end

    break 'bust' if bust?(total[:player])
  end
end

def dealer_turn(deck, hands, total)
  prompt('dealer turn...')
  until total[:dealer] >= DEALER_STAYS
    card = hit(:dealer, deck, hands, total)
    prompt("the deaer drew a #{format_cards([card])}")
  end

  if total[:dealer] > MAXIMUM
    'bust'
  else
    prompt("the dealer stays at #{total[:dealer]}")
  end
end

def determine_winner(total, round_wins)
  case total[:dealer] <=> total[:player]
  when -1
    round_wins[:player] += 1
    'player'
  when 0
    'draw'
  when 1
    round_wins[:dealer] += 1
    'dealer'
  end
end

def reset(hands, deck, cards)
  clear_screen
  hands.each { |k, _| hands[k] = [] }
  deck.each { |k, _| deck[k] = cards.clone }
end

def play_again?
  prompt('will you play again? (y/yes or n/no)')
  loop do
    ans = gets.chomp
    case ans
    when /\b(y|yes)\b/i then break true
    when /\b(n|no)\b/i then break false
    else prompt('please input either y/yes or n/no')
    end
  end
end

def display_welcome_message
  clear_screen
  prompt(INTRODUCTION)
end

def display_round_wins(round_wins)
  puts "YOU: #{round_wins[:player]}"
  puts "CPU: #{round_wins[:dealer]}"
  puts ""
end

def grand_winner?(round_wins)
  round_wins.value?(MAX_WINS)
end

def display_grand_winner(round_wins)
  if round_wins[:player] == MAX_WINS
    prompt('everlasting blackjack glory is thine!!'.upcase)
  else
    prompt('crushing defeat!!'.upcase)
  end
end

display_welcome_message
round_wins = { player: 0, dealer: 0 }
loop do
  deal_hands(deck, hands)
  display_round_wins(round_wins)
  byebug
  total = { player: score_hand(hands[:player]),
            dealer: score_hand(hands[:dealer]) }

  if player_turn(deck, hands, total) == 'bust'
    prompt('you bust!')
    round_wins[:dealer] += 1
    display_winner('dealer', hands, total)
  elsif dealer_turn(deck, hands, total) == 'bust'
    prompt('the dealer bust!')
    round_wins[:player] += 1
    display_winner('player', hands, total)
  else
    display_winner(determine_winner(total, round_wins), hands, total)
  end

  if grand_winner?(round_wins)
    display_grand_winner(round_wins)
    break
  end

  play_again? ? reset(hands, deck, cards) : break
end
prompt('thanks for playing!!')