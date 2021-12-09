Coordinates = Struct.new(:row, :col) do
  def valid?(row_max, col_max)
    return false if row.negative? || col.negative?
    return false if row > row_max || col > col_max

    true
  end
end

class HeightMap
  def initialize(input)
    @matrix = input.map { |row| row.chars.map(&:to_i) }
  end

  def total_risk_level
    low_points
      .flatten
      .map(&:next)
      .sum
  end

  private

  def low_points
    @matrix.map.with_index do |row, row_number|
      row.filter_map.with_index do |value, column_number|
        coordinates = Coordinates.new(row_number, column_number)

        value if neighbors_from(coordinates).all? { |neighbor| neighbor > value }
      end
    end
  end

  def column_max_index
    @matrix.first.count - 1
  end

  def row_max_index
    @matrix.count - 1
  end

  def neighbors_from(coordinates)
    valid_coordinates_from(coordinates).map do |coords|
      @matrix[coords.row][coords.col]
    end
  end

  def valid_coordinates_from(coordinates)
    [
      Coordinates.new(coordinates.row, coordinates.col - 1),
      Coordinates.new(coordinates.row, coordinates.col + 1),
      Coordinates.new(coordinates.row - 1, coordinates.col),
      Coordinates.new(coordinates.row + 1, coordinates.col),
    ]
      .select { |coords| coords.valid?(row_max_index, column_max_index) }
  end
end

p(
  HeightMap
    .new(File.readlines('input.txt', chomp: true))
    .total_risk_level
)
