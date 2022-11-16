class Person
  attr_accessor :first_name, :last_name

  def initialize(n)
    set_first_or_firstandlast(n)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(name)
    set_first_or_firstandlast(name)
  end

  private
  def set_first_or_firstandlast(n)
    parts = n.split
    @first_name = parts.first
    @last_name = (parts.size > 1 ? parts.last : '')
  end
end

p bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
p bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'
p 
p bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'