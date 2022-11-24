class Board
  attr_accessor :squares

  SIDE = 3
  WIN_CONDITIONS = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                   [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                   [[1, 5, 9], [3, 5, 7]] #
  def initialize
    @squares = {}
    (1..(SIDE**2)).each { |i| squares[i] = Square.new }
  end

  def get_square_at(num)
    squares[num]
  end

  def set_square_at(num, marker)
    squares[num] = Square.new(marker)
  end

  def unmarked_keys
    squares.select { |_, v| v.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def winner?
    !!detect_winner
  end

  def reset
    (1..(SIDE**2)).each { |i| squares[i] = Square.new }
  end

  def detect_winner
    WIN_CONDITIONS.each do |line|
      winning_mark = squares[line[0]].marker
      winning_sequence = winning_mark * 3
      next if winning_mark == Square::INITIAL_MARKER

      row_sequence = line.map { |s| squares[s].marker }.join
      return winning_mark if row_sequence == winning_sequence
    end
    nil
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
    # choose_marker
  end

  def mark; end

  def choose_marker
    mark = nil
    loop do
      mark = gets.chomp
      break
    end
    self.marker = mark
  end
end

class TTTGame
  attr_reader :board, :human, :computer

  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  def initialize
    @board = Board.new
    @human = Player.new('X')
    @computer = Player.new('O')
  end

  def display_welcome_message
    puts "let's play some tic tac toe!\n\n"
  end

  def display_goodbye_message
    puts 'thanks for playing!'
  end

  def human_move
    puts "choose a square: #{board.unmarked_keys.join(', ')}"
    choice = valid_choice
    board.set_square_at(choice, human.marker)
  end

  def valid_choice
    loop do
      choice = gets.chomp.to_i
      break choice if board.unmarked_keys.map(&:to_i).include?(choice)
      puts "invalid input. try again."
    end
  end

  def computer_move
    board.set_square_at(board.unmarked_keys.sample, computer.marker)
  end

  def full?
    unmarked_keys.empty?
  end

  def display_board
    system 'clear'
    puts "you are #{human.marker} and the computer is #{computer.marker}"
    squares = board.squares
    dividing_line = "-----+-----+-----"
    padding_line = "     |     |"
    row1 = "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    row2 = "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    row3 = "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    padded1 = [padding_line, row1, padding_line]
    padded2 = [padding_line, row2, padding_line]
    padded3 = [padding_line, row3, padding_line]
    puts [padded1, dividing_line, padded2, dividing_line, padded3]
  end

  def display_result
    puts case board.detect_winner
         when HUMAN_MARKER then 'you win!'
         when COMPUTER_MARKER then 'the computer wins!'
         else "it's a draw!"
         end
  end

  def play_again?
      puts 'would you like to play again?'
      puts "input 'y' to play again or anything else to quit"
      ans = gets.chomp.downcase
      ans == 'y'
  end

  def play
    display_welcome_message
    loop do
      display_board
      loop do
        human_move
        break if board.full? || board.winner?

        computer_move
        break if board.full? || board.winner?

        display_board
      end
      display_result
      play_again? ? board.reset : break
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
