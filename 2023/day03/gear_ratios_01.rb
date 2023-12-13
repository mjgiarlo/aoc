PartSymbol = Struct.new(:row_number, :column_number)
PartNumber = Struct.new(:value, :row_number, :column_number) do
  def adjacent_to?(symbols)
    symbols.any? do |symbol|
      (row_number - symbol.row_number).abs <= 1 && column_adjacency_range.cover?(symbol.column_number)
    end
  end

  def column_adjacency_range
    (column_number - 1)...(column_number + length + 1)
  end

  def length
    value.chars.length
  end

  def to_i
    value.to_i
  end
end


class Schematic
  def initialize(lines:)
    @lines = lines
  end

  def part_numbers
    @lines.flat_map.with_index do |line, row_number|
      line.gsub(/\d+/).map { |value| PartNumber.new(value, row_number, Regexp.last_match.begin(0)) }
    end
  end

  def symbols
    @lines.flat_map.with_index do |line, row_number|
      line.gsub(/[^\d\.]/).map { |value| PartSymbol.new(row_number, Regexp.last_match.begin(0)) }
    end
  end
end

class PartNumberFinder
  def self.find(schematic:)
    new(schematic:).find
  end

  def initialize(schematic:)
    @part_numbers = schematic.part_numbers
    @symbols = schematic.symbols
  end

  def find
    @part_numbers.select { |part_number| part_number.adjacent_to?(@symbols) }
  end
end

p(
  PartNumberFinder
    .find(schematic: Schematic.new(lines: File.readlines('input.txt', chomp: true)))
    .sum(&:to_i)
)
