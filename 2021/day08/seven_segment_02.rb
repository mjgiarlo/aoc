class DisplayDecoder
  DIGIT_PATTERNS = {
    0 => 'abcefg',
    1 => 'cf',
    2 => 'acdeg',
    3 => 'acdfg',
    4 => 'bcdf',
    5 => 'abdfg',
    6 => 'abdefg',
    7 => 'acf',
    8 => 'abcdefg',
    9 => 'abcdfg'
  }

  def initialize(signal_patterns, output_values)
    @output_values = output_values.split
    @signal_patterns = unscramble_signal_patterns(signal_patterns.split)
  end

  def decode
    @signal_patterns.map do |pattern|
      candidate_pattern_results = apply_pattern_to_values(pattern)
      return candidate_pattern_results.join.to_i if candidate_pattern_results.all?
    end
  end

  private

  def apply_pattern_to_values(pattern)
    @output_values.map do |value|
      pattern.transform_values { |pattern| pattern.chars.sort.join }.key(value.chars.sort.join)
    end
  end

  def unscramble_signal_patterns(signal_patterns)
    possible_mappings_from(signal_patterns).map do |wire_mapping|
      DIGIT_PATTERNS.transform_values do |pattern|
        pattern.chars.map.with_index { |char, i| wire_mapping[index_of(char)] }.join
      end
    end
  end

  def index_of(char)
    possible_wires.index(char)
  end

  def possible_wires
    ('a'..'g').to_a
  end

   def possible_mappings_from(signal_patterns)
    mappings = {}

    mappings['c'] = mappings['f'] = signal_patterns
                                      .find { |pattern| pattern.size == 2 }
                                      .chars
                                      .reject { |char| mappings.values.include?(char) }
    mappings['a'] = signal_patterns
                      .find { |pattern| pattern.size == 3 }
                      .chars
                      .reject { |char| mappings.values.include?(char) }

    mappings['b'] = mappings['d'] = signal_patterns
                                      .find { |pattern| pattern.size == 4 }
                                      .chars
                                      .reject { |char| mappings.values.include?(char) }

    mappings['e'] = mappings['g'] = signal_patterns
                                      .find { |pattern| pattern.size == 7 }
                                      .chars
                                      .reject { |char| mappings.values.include?(char) }

    mappings = mappings.sort.map(&:last)

    mappings[0].product(*mappings[1..-1]).reject { |candidate| candidate.size != candidate.uniq.size  }
   end
end

p(
  File
    .readlines('oneline.txt', chomp: true)
    .map { |display| DisplayDecoder.new(*display.split(' | ')) }
    .map(&:decode)
    .sum
)

p(
  File
    .readlines('test.txt', chomp: true)
    .map { |display| DisplayDecoder.new(*display.split(' | ')) }
    .map(&:decode)
    .sum
)

p(
  File
    .readlines('input.txt', chomp: true)
    .map { |display| DisplayDecoder.new(*display.split(' | ')) }
    .map(&:decode)
    .sum
)
