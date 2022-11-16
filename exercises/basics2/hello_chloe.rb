class Cat
  attr_accessor :name

  def initialize(name)
    rename(name)
  end

  def rename(name)
    @name = name
  end
end

p kitty = Cat.new('Sophie')
p kitty.name
p kitty.rename('Chloe')
p kitty.name