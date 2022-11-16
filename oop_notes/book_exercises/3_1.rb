module OffRoad
  OFFROADING = 'extreme'
  def off_road_capability
    "your vehicle's ability to offroad is: #{OFFROADING}"
  end
end

class Vehicle
  attr_reader :year
  attr_accessor :color, :model
  @@number_of_vehicles = 0

  def initialize(y, c, m)
    @speed = 0
    @year = y
    @color = c
    @model = m
    @@number_of_vehicles += 1
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

  def self.gas_mileage(miles, gallons)
    "your car gets #{(miles.to_f / gallons).round(2)} miles to the gallon"
  end

  def self.number_of_vehicles
    "#{@@number_of_vehicles}"
  end

  def how_old?
    "your vehicle is #{age} years old"
  end

  private
  def age
    Time.now.year - year
  end
end

class MyCar < Vehicle
  VEHICLE_TYPE = 'car'

  def to_s
    "my car is a #{@color} #{@year} #{@model}."
  end

  def type
    VEHICLE_TYPE
  end
end

class MyTruck < Vehicle
  include OffRoad
  VEHICLE_TYPE = 'truck'

  def type
    VEHICLE_TYPE
  end
end

my_car = MyCar.new(1998, 'red', 'Rav 4')
p my_car.speed
p my_car.color
p my_car.type
ford = MyTruck.new(2000, 'black', 'tundra')
p ford.type
p ford.color
p Vehicle.number_of_vehicles
p ford.off_road_capability
p MyTruck.ancestors
p MyCar.ancestors
ford.speed_up(100)
p ford.speed
p ford.how_old?
p ford.age