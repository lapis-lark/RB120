class Student
  
  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(student)
    grade > student.grade
  end

  protected
  attr_accessor :name, :grade
end

joe = Student.new('joe', 97)
bob = Student.new('bob', 93)

puts "Well done!" if joe.better_grade_than?(bob)
puts joe.name