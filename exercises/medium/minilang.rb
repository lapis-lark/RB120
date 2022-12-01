require 'byebug'

=begin
  PROBLEM: Write a minilang stack-and-register program
      COMPONENTS:
                Place value in register
                PUSH register value to stack
                ADD
  DATA:
    INPUT: string of space separated commands
    OUTPUT:

=end
class Minilang
  def eval
    @register = 0
    @stack = []
    format_commands
    execute_commands
  end

  private
  
  def initialize(commands)
    @commands= commands
  end

  def format_commands
    self.commands = commands.split.map do |c|
      c.to_i.to_s == c ? c.to_i : c.downcase.to_sym
    end
  end

  def execute_commands
    commands.each do |c|
      begin
        if c.is_a?(Integer)
          make_register(c)
        else
          send(c)
        end
      rescue NoMethodError
        puts "no method called '#{c}' found"
        break
      rescue IndexError
        puts 'error: no value in stack'
        break
      end
    end
  end

  def print
    puts register
  end

  def make_register(n)
    self.register = n
  end

  def push
    stack << register
  end

  def add
    self.register += pop
  end

  def sub
    self.register -= pop
  end

  def mult
    self.register *= pop
  end

  def div
    self.register /= pop
  end

  def mod
    self.register %= pop
  end

  def pop
    stack.fetch(-1)
    self.register = stack.pop
  end

  attr_accessor :register, :stack, :commands
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
