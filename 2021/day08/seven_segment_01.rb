UNIQUE_DIGIT_VALUES = [2, 3, 4, 7].freeze

p(
  File
    .readlines('input.txt', chomp: true)
    .map { |display| display.split(' | ').last.split.map(&:size) }
    .map { |display_lengths| display_lengths.count { |length| UNIQUE_DIGIT_VALUES.include?(length) } }
    .sum
)
