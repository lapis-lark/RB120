class Cat
  COLOR = 'tortoise shell'
  def initialize(n)
    @name = n
  end
  def greet
    puts "osaaa! ore ha #{@name} da ze! ke ha #{COLOR}-iro da!"
  end
end

kitty = Cat.new('Taka')
kitty.greet