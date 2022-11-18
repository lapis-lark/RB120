class Vehicle
  attr_reader :make, :model
  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end
end

class Car
  def wheels
    4
  end
end

class Motorcycle
  attr_reader :make, :model
  def wheels
    2
  end
end

class Truck
  attr_reader :make, :model, :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end