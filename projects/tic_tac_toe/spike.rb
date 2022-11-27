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

  def []=(num, marker)
    squares[num] = Square.new(marker)
  end

  def unmarked_keys
    squares.select { |_, v| v.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def winner?
    !!winning_marker
  end

  def reset
    (1..(SIDE**2)).each { |i| squares[i] = Square.new }
  end

  def winning_marker
    WIN_CONDITIONS.each do |line|
      winning_mark = squares[line[0]].marker
      winning_sequence = winning_mark * 3
      next if winning_mark == Square::INITIAL_MARKER

      row_sequence = line.map { |s| squares[s].marker }.join
      return winning_mark if row_sequence == winning_sequence
    end
    nil
  end

  def two_of_three_marked(mark)
    WIN_CONDITIONS.each do |line|
      two_marks = mark * 2
      row_sequence = line.map { |s| squares[s].marker }.join

      if row_sequence.count(mark) == 2 && row_sequence.count(' ') == 1
        return line[row_sequence.chars.index(' ')]
      end
    end
  end

  def display
    squares = self.squares
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
  attr_accessor :marker, :score

  def initialize(marker)
    @marker = marker
    @score = 0
    # choose_marker
  end

  def choose_marker
    mark = nil
    loop do
      mark = gets.chomp
      break if mark.length == 1 && ![INITIAL_MARKER,
                                     COMPUTER_MARKER].include(mark)
      puts 'invalid input. input a non-whitespace single character.'
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
    @human_turn = [true, false].sample
  end

  def choose_moves_until_winner
    loop do
      current_player_moves
      break if board.full? || board.winner?
      clear_screen_and_display_board if human_turn?
    end
  end

  def update_scores
    case board.winning_marker
    when HUMAN_MARKER then human.score += 1
    when COMPUTER_MARKER then computer.score += 1
    end
  end

  def display_score
    puts "YOU: #{human.score}   CPU: #{computer.score}"
  end

  def play
    display_welcome_message
    loop do
      display_board
      choose_moves_until_winner
      display_result
      update_scores
      break unless play_again?
      reset
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "let's play some tic tac toe!\n\n"
  end

  def display_goodbye_message
    puts 'thanks for playing!'
  end

  def joinor(keys)
    keys[0...-1].join(', ') + " or #{keys[-1]}"
  end

  def human_move
    puts "choose a square: #{joinor(board.unmarked_keys)}"
    choice = valid_choice
    board[choice] = human.marker
  end

  def valid_choice
    loop do
      choice = gets.chomp.to_i
      break choice if board.unmarked_keys.map(&:to_i).include?(choice)
      puts "invalid input. try again."
    end
  end

  def computer_defense
    board[board.two_of_three_marked(human.marker)] = computer.marker
  end

  def computer_offense
    board[board.two_of_three_marked(computer.marker)] = computer.marker
  end

  def computer_random
    board[board.unmarked_keys.sample] = computer.marker
  end

  def computer_move
    if board.two_of_three_marked(COMPUTER_MARKER)
      computer_offense
    elsif board.two_of_three_marked(HUMAN_MARKER)
      computer_defense
    else
      computer_random
    end

    board[board.unmarked_keys.sample] = computer.marker
  end

  def full?
    unmarked_keys.empty?
  end

  def clear
    system 'clear'
  end

  def display_board
    puts display_score
    puts "you are #{human.marker} and the computer is #{computer.marker}"
    board.display
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_result
    puts case board.winning_marker
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

  def reset
    board.reset
    clear
  end

  def display_play_again_message
    puts "let's play again ^^"
    puts
  end

  def current_player_moves
    # byebug
    human_turn ? human_move : computer_move
    self.human_turn = !human_turn
  end

  def human_turn?
    human_turn
  end

  attr_accessor :human_turn
end

game = TTTGame.new
game.play
