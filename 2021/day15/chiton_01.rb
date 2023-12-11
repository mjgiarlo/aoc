Coordinates = Struct.new(:row, :col, :row_max, :col_max, :value) do
  def starting?
    row.zero? && col.zero?
  end

  def destination?
    row == row_max && col == col_max
  end

  def neighbor_locations
    # Only move down and right (towards the destination)
    [[row, col + 1], [row + 1, col]].reject { |row_number, col_number| row_number > row_max || col_number > col_max }
  end

  def inspect
    "#{row},#{col}"
  end
end

class Path
  def initialize(*steps)
    @steps = *steps
  end

  def last
    @steps.last
  end

  def reached_destination?
    last.destination?
  end

  def for(*steps)
    self.class.new(*(@steps + steps))
  end

  def include?(step)
    @steps.include?(step)
  end

  def sum
    @steps
      .map(&:value)
      .sum - @steps.first.value
  end

  def size
    @steps.size
  end

  def inspect
    "#{self.class}#{@steps}"
  end
end

class PathFinder
  def initialize(input)
    values = input.map(&:chars)

    @rows = values.size
    @cols = values.first.size
    @matrix = values.flat_map.with_index do |row, row_number|
                row.map.with_index do |value, col_number|
                  Coordinates.new(row_number, col_number, @rows - 1, @cols - 1, value.to_i)
                end
              end
    @paths = paths_from(paths: [Path.new(starting_coords)])
  end

  def path_of_least_risk_sum
    p(number_of_paths)
    p(@paths.size)
    @paths
      .min_by { |path| path.sum }
      .sum
  end

  private

  def paths_from(paths:)
    possible_paths = paths.map do |path|
      next path if path.reached_destination?

      neighbors_from(path.last).filter_map { |coords| path.for(coords) unless path.include?(coords) }
    end.flatten

    return possible_paths if possible_paths.all?(&:reached_destination?)#.size == number_of_paths

    paths_from(paths: possible_paths)
  end

  def neighbors_from(coords)
    coords.neighbor_locations.map { |row, col| @matrix.find { |coords| coords.row == row && coords.col == col } }
  end

  def starting_coords
    @matrix.find(&:starting?)
  end

  def number_of_paths
    @number_of_paths ||= count_possible_paths(@rows, @cols)
  end

  def count_possible_paths(x, y)
    return 1 if x == 1 || y == 1

    count_possible_paths(x - 1, y) + count_possible_paths(x, y - 1)
  end
end

pp(
  PathFinder.new(File.readlines('test.txt', chomp: true))
    .path_of_least_risk_sum
)
