module Displayable
  def display_welcome_message
    puts "let's play some rock, paper, scissors!"
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

  def display_scores
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_grand_winner
    if human.score == RPSGame::PLAY_TO
      puts "#{human.name} is the grand champion!"
    else
      puts "#{computer.name} is the grand champion!"
      puts "better luck next time!"
    end

    puts "final scores:"
    display_scores
    puts "thanks for playing ;)"
    puts human.move_history
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
    !(self > other)
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
  FULL_MOVE = {'r' => 'rock', 'p' => 'paper', 's' => 'scissors',
                'l' => 'lizard','sp' => 'spock'}
  def set_name
    puts "what's your name?"
    self.name = gets.chomp
  end

  def choose
    choice = nil
    loop do
      puts "please enter 'r', 'p', 's', 'l', or 'sp' (rock, paper, scissors, lizard, spock)"
      choice = gets.chomp
      break if Move::VALUES.include?(FULL_MOVE[choice])
      puts 'invalid input. try again.'
    end
    choice = Move.new(FULL_MOVE[choice])
    self.move = choice
    move_history << choice
  end
end

class Computer < Player
  def set_name
    self.name = %w(Frodo Sauron Pippin Mary).sample
  end

  def choose
    choice = Move.new(Move::VALUES.sample)
    self.move = choice
    move_history << choice
  end
end

class RPSGame
  include Displayable
  PLAY_TO = 3
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def update_scores
    if human.move > computer.move
      human.score += 1
      human.victory_history << 'won'
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def grand_winner?
    [human.score, computer.score].include?(PLAY_TO)
  end

  def play_again?
    ans = nil
    loop do
      puts 'play again? (y/n)'
      ans = gets.chomp
      break if %w(y n).include?(ans)
      puts 'invalid input. try again.'
    end
    ans == 'y'
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_choices
      display_winner
      update_scores
      display_scores
      break if grand_winner?
    end
    display_grand_winner
  end
end

RPSGame.new.play
