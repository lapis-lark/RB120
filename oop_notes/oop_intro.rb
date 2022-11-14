class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{name} says arf!"
  end

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{name} weighs #{height} and is #{weight} tall."
  end
end

dog = GoodDog.new('gizmo', '10 pounds', '1 foot')
p dog.info
dog.change_info('theodora', '100 pounds', '4 feet')
p dog.info