class GuessingGame
  def play
    loop do
      self.guess = valid_guess
      self.guesses_remaining -= 1
      evaluate_guess(guess)
      break if guess == secret_num || guesses_remaining.zero?
    end
    if guess == secret_num
      puts "thanks for playing!"
    else
      puts "you're out of guesses, but feel free to try again!"
    end
  end

  private

  def initialize(low, high)
    @range = low..high
    @secret_num = rand(range)
    @guesses_remaining = Math.log2(high - low).to_i + 1
    @guess = nil
  end



  def valid_guess
    guess = nil
    
    loop do 
      puts "You have #{guesses_remaining} guesses remaining."
      puts "Enter a number between #{range.min} and #{range.max}"
      guess = gets.to_i
      break if range === guess
      puts "invalid input. try again."
    end

    guess
  end

  def evaluate_guess(guess)
    puts (case guess
         when (range.min...secret_num) then 'your guess is too low'
         when secret_num then 'you guessed right!'
         else 'your guess is too high'
         end)
      
  end

  attr_reader :secret_num, :range
  attr_accessor :guesses_remaining, :guess
end

GuessingGame.new(501, 1500).play