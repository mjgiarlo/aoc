class CalibrationValueDecoder
  VALID_STRING_PATTERNS = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9'
  }
  VALID_VALUE_PATTERN = /(?=(\d|#{VALID_STRING_PATTERNS.keys.join('|')}))/

  def self.decode(calibration_value)
    valid_values = calibration_value.scan(VALID_VALUE_PATTERN).flatten
    [
      VALID_STRING_PATTERNS.fetch(valid_values.first, valid_values.first),
      VALID_STRING_PATTERNS.fetch(valid_values.last, valid_values.last),
    ]
      .join
      .to_i
  end
end

p(
  File
    .foreach('input.txt')
    .map { |calibration_value| CalibrationValueDecoder.decode(calibration_value) }
    .sum
)
