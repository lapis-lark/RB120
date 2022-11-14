class MyCar
  attr_reader :year
  attr_accessor :color, :model
  def initialize(y, c, m)
    @speed = 0
    @year = y
    @color = c
    @model = m
  end

  def brake(sub_speed)
    @speed -= sub_speed
    @speed = 0 if @speed < 0 
  end

  def speed_up(add_speed)
    @speed += add_speed
  end

  def shut_off
    @speed = 0
  end

  def speed
    @speed
  end

  def spray_paint(c)
    self.color = c
  end
end

my_car = MyCar.new(1998, 'red', 'Rav 4')
puts my_car.speed
my_car.speed_up(50)
puts my_car.speed
my_car.brake(30)
puts my_car.speed
puts my_car.color
my_car.spray_paint('silvery purple')
puts my_car.color






