module Displayable
  def clear_screen
    system('clear')
  end

  def display_welcome_message
    clear_screen
    puts "let's play some #{Move::VALUES.join(', ')}!"
    puts "the first person to #{self.class::PLAY_TO} points wins!"
    puts "type 'rules' to see the rules or anything else to continue"
    input = gets.chomp.downcase
    display_rules if input == 'rules'
    clear_screen
  end

  def display_rules
    clear_screen
    puts "you and your opponent will each choose a hand to throw."
    puts "if your hand beats theirs, you gain a point, and vice versa."
    puts "no one gets a point if there is a tie."
    puts ''
    Move::WIN_CONDITIONS.each do |k, v|
      puts "#{k} beats: #{v.join(', ')}"
    end
    puts "\npress enter to continue"
    gets
  end

  def display_choices
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} wins!"
    elsif computer.move > human.move
      puts "#{computer.name} wins! better luck next time!"
    else
      puts "it's a tie!"
    end
  end

  def display_move_history
    puts
    human.move_history.size.times do |i|
      puts "round #{i + 1}: #{human.move_history[i]} vs."\
           " #{computer.move_history[i]} [#{human.victory_history[i]}]"
    end
    puts
  end

  def display_scores
    message = ("#{' ' * 10}#{human.name.upcase}: #{human.score}#{' ' * 10}"\
         "#{computer.name.upcase}: #{computer.score}#{' ' * 10}")
    puts message
    puts "*#{'-' * message.size}*"
  end

  def display_grand_winner
    if human.score == self.class::PLAY_TO
      puts "#{human.name} is the grand champion!"
    else
      puts "#{computer.name} is the grand champion!"
      puts "better luck next time!"
    end
    puts
    display_goodbye_message
  end

  def display_goodbye_message
    display_scores
    display_move_history
    puts "\nthanks for playing!"
  end
end

class Move
  WIN_CONDITIONS = { 'rock' => ['scissors', 'lizard'],
                     'paper' => ['rock', 'spock'],
                     'scissors' => ['paper', 'lizard'],
                     'lizard' => ['spock', 'paper'],
                     'spock' => ['scissors', 'rock'] }
  VALUES = WIN_CONDITIONS.keys
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other)
    WIN_CONDITIONS[value].include?(other.value)
  end

  def ==(other)
    value == other.value
  end

  def <(other)
    WIN_CONDITIONS[other.value].include?(value)
  end

  def to_s
    value
  end
end

class Player
  attr_reader :move, :name
  attr_accessor :score, :move_history, :victory_history

  def initialize
    set_name
    @score = 0
    @move_history = []
    @victory_history = []
  end

  private

  attr_writer :move, :name
end

class Human < Player
  FULL_MOVE = { 'r' => 'rock', 'p' => 'paper', 's' => 'scissors',
                'l' => 'lizard', 'sp' => 'spock' }
  def set_name
    n = nil
    loop do
      puts "what's your name?"
      n = gets.chomp
      break unless n.strip.empty? || n.size > 16
      puts "invalid input. please input a non-whitespace "\
            "string less than 16 characters"
    end
    self.name = n.strip
  end

  def valid_choice
    choice = nil
    loop do
      puts "please enter 'r', 'p', 's', 'l', or 'sp'"\
           " (rock, paper, scissors, lizard, spock)"
      choice = gets.chomp
      break if Move::VALUES.include?(FULL_MOVE[choice])
      puts 'invalid input. try again.'
    end
    Move.new(FULL_MOVE[choice])
  end

  def choose
    choice = valid_choice
    self.move = choice
    move_history << choice
  end
end

class Computer < Player
  CPUS = { "randy random" => Move::VALUES,
           "it learns" => [Move::VALUES.sample],
           "it loses" => [Move::VALUES.sample] }

  def set_name
    choice = nil
    loop do
      puts "choose your opponent:"
      puts CPUS.keys
      choice = gets.chomp
      break if CPUS.keys.include?(choice)
      puts "invalid input. try again."
    end
    self.name = choice
  end

  def choose
    choice = Move.new(CPUS[name].sample)
    self.move = choice
    move_history << choice
  end
end

class RPSGame
  include Displayable
  PLAY_TO = 5
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def update_scores
    history = human.victory_history
    if human.move > computer.move
      human.score += 1
      history << 'won'
    elsif computer.move > human.move
      computer.score += 1
      history << 'lost'
    else
      history << 'tied'
    end
  end

  def grand_winner?
    [human.score, computer.score].include?(PLAY_TO)
  end

  def play_again?
    puts "input 'q' to quit or anything else to continue"
    ans = gets.chomp.downcase
    ans != 'q'
  end

  def update_cpu_behavior
    new_behavior = []
    case computer.name
    when 'it learns'
      Move::VALUES.each { |m| new_behavior << m if human.move < Move.new(m) }
    when "it loses"
      new_behavior = Move::WIN_CONDITIONS[human.move.value]
    else
      return
    end
    Computer::CPUS[computer.name] = new_behavior
  end

  def update
    update_scores
    update_cpu_behavior
  end

  def display_results
    display_choices
    display_winner
  end

  def choose_hands
    human.choose
    computer.choose
  end

  def main_loop
    loop do
      clear_screen
      display_scores
      display_move_history
      choose_hands
      display_results
      update
      break if grand_winner?
      break unless play_again?
    end
  end

  def play
    display_welcome_message
    main_loop
    clear_screen
    grand_winner? ? display_grand_winner : display_goodbye_message
  end
end

RPSGame.new.play
