class Animal
  def speak(sound)
    p sound
  end
end

module Mammal
  class Dog < Animal
  end
end

hank = Mammal::Dog.new
hank.speak('roof')
p Animal.ancestors