class Greeting
  def greet(str)
    puts str
  end
end

class Hello < Greeting
  def hi
    greet('hello')
  end
end

class Goodbye < Greeting
  def bye
    greet('bye')
  end
end