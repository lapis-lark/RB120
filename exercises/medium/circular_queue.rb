=begin
  PROBLEM: add item to circular queue; items are not ordered
  EXAMPLE: if room in buffer, add value; if not, boot oldest value, then add to buffer
  DATA: arrays
    INPUT: QueueItem object (value + age of object)
    OUTPUT: none

=end

class CircularQueue
  def initialize(buffer_size)
    @buffer_size = buffer_size
    @elements = []
  end

  def enqueue(value)
    if elements.size < buffer_size
      elements <<  value
    else
      dequeue
      elements << value
    end
  end

  def dequeue
    elements.shift
  end

  private

  attr_accessor :age, :elements, :buffer_size
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil