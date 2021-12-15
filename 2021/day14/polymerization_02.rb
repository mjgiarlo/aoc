class PolymerFinder
  def initialize(lines)
    @template = lines.first
    @pair_tally = @template.chars.each_cons(2).tally
    @pair_tally.default = 0
    @rules = lines[2..].map { |rule| rule.split(' -> ') }.to_h
  end

  def apply_rules(number)
    number.times do
      new_pair_tally = {}
      new_pair_tally.default = 0

      @pair_tally.each do |(char1, char2), count|
        insert = @rules[char1 + char2]

        new_pair_tally[[char1, insert]] += count
        new_pair_tally[[insert, char2]] += count
      end

      @pair_tally = new_pair_tally
    end

    self
  end

  def greatest_commonness_distance
    element_tally = {}
    element_tally.default = 0
    @pair_tally.each { |(char1, char2), count| element_tally[char1] += count }
    element_tally[@template[-1]] += 1
    element_tally.values.minmax.reverse.reduce(:-)
  end
end

p(
  PolymerFinder.new(File.readlines('input.txt', chomp: true))
    .apply_rules(40)
    .greatest_commonness_distance
)
