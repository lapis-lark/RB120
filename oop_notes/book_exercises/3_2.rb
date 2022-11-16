class Person
  attr_accessor :name
  def initialize(n)
    @name = n
  end
end

p bob = Person.new("Steve")
p bob.name = "Bob"