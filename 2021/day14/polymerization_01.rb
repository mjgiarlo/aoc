class PolymerFinder
  def initialize(lines)
    @template = lines.first
    @rules = lines[2..].map { |rule| rule.split(' -> ') }
  end

  def apply_rules(times)
    1.upto(times) do
      @rules
        .filter_map { |pair, insert| indices_of(pair).map { |index| [index, insert] } if @template.match?(pair) }
        .flatten(1)
        .sort
        .reverse
        .each { |position, char| @template.insert(position, char) }
    end

    self
  end

  def greatest_commonness_distance
    most_common_character_count - least_common_character_count
  end

  private

  def most_common_character_count
    @template.chars.tally.max_by { |_, count| count }.last
  end

  def least_common_character_count
    @template.chars.tally.min_by { |_, count| count }.last
  end

  def indices_of(pair)
    [].tap do |indices|
      @template.chars.each_cons(2).with_index(1) do |template_pair, i|
        indices << i if template_pair == pair.chars
      end
    end
  end
end

p(
  PolymerFinder.new(File.readlines('input.txt', chomp: true))
    .apply_rules(10)
    .greatest_commonness_distance
)
