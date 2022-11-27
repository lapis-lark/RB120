class Move
  def >(other)
    self::BEATS.include?(other)
  end 
end

class Rock < Move
  BEATS = [Scissors]
end

class Paper < Move
  BEATS = [Rock]
end

class Scissors < Move
  BEATS = [Paper]
end

p Rock.new > Paper.new
p Scissors.new > Paper.new