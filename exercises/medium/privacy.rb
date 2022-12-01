class Machine
  def start
    self.flip_switch(:on)
  end

  def stop
    self.flip_switch(:off)
  end

  def display_state
    puts switch
  end


  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

x = Machine.new

x.display_state # attrivute is nil, so just a newline output
x.start # turned on
x.display_state # on
