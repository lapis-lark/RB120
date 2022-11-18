class Person
  def name=(n)
    @name = n.downcase!
    n[0] = n[0].upcase
  end 
  def name
    @name
  end
end

person1 = Person.new
person1.name = 'eLiZaBeTh'
puts person1.name