Coordinates = Struct.new(:row, :col, :value) do
  def valid?(row_max, col_max)
    return false if row.negative? || col.negative?
    return false if row > row_max || col > col_max

    true
  end

  def excluded_from_basin?
    value == 9
  end
end

class HeightMap
  def initialize(input)
    @matrix = input.map { |row| row.chars.map(&:to_i) }
  end

  def top_three_basin_height_score
    basins.max(3).reduce(:*)
  end

  private

  def basins
    low_points.map do |low_point|
      basin_from(low_point).size
    end
  end

  def recursive_neighbors_from(coordinates:, basin:)
    neighbors = coordinates.map do |neighbor_coords|
      neighbors_from(neighbor_coords).reject { |neighbor| neighbor.excluded_from_basin? || basin.include?(neighbor) }
    end.flatten.uniq
    return basin if neighbors.empty?

    recursive_neighbors_from(coordinates: neighbors, basin: basin.concat(neighbors))
  end

  def basin_from(coordinates)
    recursive_neighbors_from(coordinates: [coordinates], basin: [coordinates])
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
    valid_coordinates_from(coordinates)
      .map { |coords| coords.tap { |coord| coord.value = @matrix[coords.row][coords.col] } }
  end

  def valid_coordinates_from(coordinates)
    [
      Coordinates.new(coordinates.row, coordinates.col - 1),
      Coordinates.new(coordinates.row, coordinates.col + 1),
      Coordinates.new(coordinates.row - 1, coordinates.col),
      Coordinates.new(coordinates.row + 1, coordinates.col),
    ].select { |coords| coords.valid?(row_max_index, column_max_index) }
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
    .top_three_basin_height_score
)
