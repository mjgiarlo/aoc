class CalibrationValueDecoder
  VALID_VALUE_PATTERN = /\d/

  def self.decode(calibration_value)
    valid_values = calibration_value.scan(VALID_VALUE_PATTERN)
    [
      valid_values.first,
      valid_values.last
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
