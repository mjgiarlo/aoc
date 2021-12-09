Coordinates = Struct.new(:row, :col, :value) do
  NOT_BASINWORTHY = 9

  def valid?(row_max, col_max)
    return false if row.negative? || col.negative?
    return false if row > row_max || col > col_max

    true
  end

  def excluded_from_basin?
    value == NOT_BASINWORTHY
  end

  def neighbors
    [
      Coordinates.new(row, col - 1),
      Coordinates.new(row, col + 1),
      Coordinates.new(row - 1, col),
      Coordinates.new(row + 1, col)
    ]
  end
end

class HeightMap
  def initialize(input)
    @matrix = input.map { |row| row.chars.map(&:to_i) }
  end

  def basins
    low_points.map { |low_point| basin_from(coordinates_list: [low_point]) }
  end

  private

  def basin_from(coordinates_list:, basin: [])
    # Allows the method to be called with initial state and recursively
    basin = coordinates_list if basin.empty?

    neighbors = coordinates_list
                  .map do |neighbor_coords|
                    neighbors_from(neighbor_coords)
                      .reject { |neighbor| neighbor.excluded_from_basin? || basin.include?(neighbor) }
                  end
                  .flatten
                  .uniq

    return basin if neighbors.empty?

    basin_from(coordinates_list: neighbors, basin: basin.concat(neighbors))
  end

  def low_points
    @matrix.map.with_index do |row, row_number|
      row.filter_map.with_index do |value, column_number|
        coordinates = Coordinates.new(row_number, column_number, value)

        coordinates if neighbors_from(coordinates).all? { |neighbor| neighbor.value > value }
      end
    end.flatten
  end

  def neighbors_from(coordinates)
    coordinates
      .neighbors
      .select { |coords| coords.valid?(row_max_index, column_max_index) }
      .map { |coords| coords.tap { |coord| coord.value = @matrix[coords.row][coords.col] } }
  end

  def column_max_index
    @matrix.first.size - 1
  end

  def row_max_index
    @matrix.size - 1
  end
end

p(
  HeightMap
    .new(File.readlines('input.txt', chomp: true))
    .basins
    .map(&:size)
    .max(3)
    .reduce(:*)
)
