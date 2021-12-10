class Line
  CHARACTER_PAIRS = {
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<',
  }.freeze

  def initialize(value)
    @character_stack = []
    @first_illegal_character = find_first_illegal_character(value)
  end

  def corrupted?
    !@first_illegal_character.empty?
  end

  def score
    {
      ')' => 3,
      ']' => 57,
      '}' => 1197,
      '>' => 25137
    }[@first_illegal_character]
  end

  private

  def find_first_illegal_character(value)
    value.each_char do |character|
      if opening?(character)
        @character_stack.push(character)
      else
        return character unless CHARACTER_PAIRS[character] == @character_stack.last

        @character_stack.pop
      end
    end
    ''
  end

  def opening?(character)
    ['(', '[', '{', '<'].include?(character)
  end
end

class NavigationSubsystem
  def initialize(lines)
    @lines = lines.map { |line| Line.new(line) }
  end

  def error_score
    corrupted_lines
      .map(&:score)
      .sum
  end

  private

  def corrupted_lines
    @lines.select(&:corrupted?)
  end
end

p(
  NavigationSubsystem
    .new(File.readlines('input.txt', chomp: true))
    .error_score
)
