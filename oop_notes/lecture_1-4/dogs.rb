class Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def run
    'running!'
  end

  def jump
    'jumping!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "oyogenai!"
  end
end

class Cat < Pet
  def fetch
    "can't fetch!"
  end

  def swim
    "oyogenai"
  end
end

class Dog < Pet
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           
ruby = Bulldog.new
puts ruby.swim