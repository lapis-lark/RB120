class FixedArray
  def initialize(size)
    @size = 5
    @body = [nil] * 5
    @valid_indexes = ((-size)..(size - 1)) 
  end

  def [](index)
    if @valid_indexes === index
      body[index]
    else
      body.fetch(index)
    end
  end

  def []=(index, value)
    if @valid_indexes === index
      body[index] = value
    else
      body.fetch(index)
    end
  end

  def to_a
    body.dup
  end

  def to_s
    "#{body.inspect}"
  end

  private

  attr_accessor :body, :size



end

fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]' # !

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end