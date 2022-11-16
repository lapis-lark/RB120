class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "ore ha #{name}. wasureru na."
  end
end

kitty = Cat.new('Sophie')
puts kitty