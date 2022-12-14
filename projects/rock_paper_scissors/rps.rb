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
  attr_accessor :score

  def initialize
    set_name
    @score = 0
  end

  private

  attr_writer :move, :name
end

class Human < Player
  def set_name
    puts "what's your name?"
    self.name = gets.chomp
  end

  def choose
    choice = nil
    loop do
      puts "please enter 'r', 'p', or 's' for rock, paper, or scissors"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts 'invalid input. try again.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(Frodo Sauron Pippin Mary).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  PLAY_TO = 3
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Let's play some rock, paper, scissors!"
  end

  def puts_choices
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

  def update_scores
    if human.move > computer.move
      human.score += 1
    elsif computer.move > human.move
      computer.score += 1
    end
  end

  def display_scores
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def grand_winner?
    [human.score, computer.score].include?(PLAY_TO)
  end

  def display_grand_winner
    if human.score == PLAY_TO
      puts "#{human.name} is the grand champion!"
    else
      puts "#{computer.name} is the grand champion!"
      puts "better luck next time!"
    end

    puts "final scores:"
    display_scores
    puts "Thanks for playing ;)"
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
      puts_choices
      display_winner
      update_scores
      display_scores
      break if grand_winner?
    end
    display_grand_winner
  end
end

RPSGame.new.play
