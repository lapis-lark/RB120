class Banner
  def initialize(message, width = -1)
    @message = message
    @across = width < 0 ? message.size : width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @across}-+"
  end

  def empty_line
    "| #{' ' * @across} |"
  end

  def message_line
    messages = []
    until @message.empty?
      if @message.size < @across
        messages << ('| ' + "#{@message[0...@across]}".center(@across) + ' |')
        break
      else
        messages << "| #{@message[0...@across]} |"
        @message.slice!(0, @across)
      end
    end
    messages
  end
end

banner = Banner.new('To boldly go where no one has gone before.')
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 10)
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 50)
puts banner

banner = Banner.new('To boldly go where no one has gone before.', 40)
puts banner