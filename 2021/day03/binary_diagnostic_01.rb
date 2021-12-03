class Diagnosticator
  def initialize
    @diagnostics = []
  end

  def register(diagnostic)
    @diagnostics << diagnostic
  end

  def power_consumption
    gamma * epsilon
  end

  def gamma
    @diagnostics
      .map(&:chars)
      .transpose
      .then do |by_position|
        by_position.map do |digits|
          digits.max_by { |digit| digits.count(digit) }
        end
      end
      .join
      .to_i(2)
  end

  # Turns out bitwise NOT isn't what I thought it was, so instead of using the
  # Ruby unary ~ operator, XOR gamma against a string of 1 digits of the same
  # length. That effectively flips the bits.
  def epsilon
    gamma ^ epsilon_calculator
  end

  def epsilon_calculator
    ('1' * @diagnostics.first.length).to_i(2)
  end
end

diagnosticator = Diagnosticator.new

File.foreach('input.txt', chomp: true) { |diagnostic| diagnosticator.register(diagnostic) }

p(diagnosticator.power_consumption)
