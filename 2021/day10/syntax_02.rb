class Line
  CHARACTER_PAIRS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
  }.freeze

  SCORES = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }.freeze

  def initialize(value)
    @first_illegal_character = find_first_illegal_character(value)
    @missing_characters = find_missing_characters(value)
  end

  def incomplete?
    @first_illegal_character.empty?
  end

  def score
    @missing_characters
      .map { |character| SCORES[character] }
      .reduce(0) { |total, n| (total * 5) + n }
  end

  private

  def find_missing_characters(value)
    character_stack = []

    value.each_char do |character|
      if opening?(character)
        character_stack.push(character)
      else
        character_stack.pop
      end
    end

    character_stack.reverse.map { |character| CHARACTER_PAIRS[character] }
  end

  def find_first_illegal_character(value)
    character_stack = []
    value.each_char do |character|
      if opening?(character)
        character_stack.push(character)
      else
        return character unless CHARACTER_PAIRS.key(character) == character_stack.last

        character_stack.pop
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

  def incomplete_score
    incomplete_lines
      .map(&:score)
      .sort
      .slice(incomplete_midpoint)
  end

  private

  def incomplete_lines
    @lines.select(&:incomplete?)
  end

  def incomplete_midpoint
    incomplete_lines.size / 2
  end
end

p(
  NavigationSubsystem
    .new(File.readlines('input.txt', chomp: true))
    .incomplete_score
)
