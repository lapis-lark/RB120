class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
  end
end

class Owner
  attr_accessor :number_of_pets, :name

  def initialize(name)
    @number_of_pets = 0
    @name = name
  end
end

class Shelter
  def initialize
    @adoptions = 0
    @owners = Hash.new { |h, k| h[k] = [] }
  end

  def adopt(owner, pet)
    owner.number_of_pets += 1
    @adoptions += 1
    @owners[owner] << pet
  end

  def print_adoptions
    @owners.each do |k, v|
      puts "#{k.name} has adopted the following pets:"
      v.each { |pet| puts "a #{pet.animal} called #{pet.name}" }
      puts
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
