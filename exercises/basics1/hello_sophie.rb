# frozen_string_literal: true

module Walkable
  def walk
    puts 'sanpo ni ikimashou yo!'
  end
end

class Cat
  attr_accessor :name

  include Walkable
  def initialize(n)
    @name = n
  end

  def greet
    puts "konnichiwa. watashi no namae ha #{name}"
  end
end

kitty = Cat.new('sophie')
kitty.greet
kitty.name = 'lark'
kitty.greet
kitty.walk
