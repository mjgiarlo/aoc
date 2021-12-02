class Navigator
  def initialize
    @aim = 0
    @depth = 0
    @position = 0
  end

  def navigate(direction)
    instruction, extent = direction.split
    extent = extent.to_i
    case instruction
    when 'up'
      @aim -= extent
    when 'down'
      @aim += extent
    when 'forward'
      @position += extent
      @depth += extent * @aim
    end
  end

  def solution
    @position * @depth
  end
end

navigator = Navigator.new

File.foreach('input.txt') { |direction| navigator.navigate(direction) }

p(navigator.solution)
