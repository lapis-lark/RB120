class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.generic_greeting
    puts 'atashi ha neko da nyan!'
  end

  def personal_greeting
    puts "atashi no na ha #{name}, nyan!"
  end
end

kitty = Cat.new('Sophie')

Cat.generic_greeting
kitty.personal_greeting