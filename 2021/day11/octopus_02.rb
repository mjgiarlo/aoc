Octopus = Struct.new(:row, :col, :value) do
  MAX_ENERGY = 9

  def valid?(row_max, col_max)
    return false if row > row_max || col > col_max

    true
  end

  def reset!
    self.value = 0 if flashing?
  end

  def increment!
    self.value += 1

    self
  end

  def flashing?
    value > MAX_ENERGY
  end

  def neighbors
    [
      [row, col - 1],
      [row, col + 1],
      [row - 1, col],
      [row + 1, col],
      [row - 1, col - 1],
      [row - 1, col + 1],
      [row + 1, col - 1],
      [row + 1, col + 1]
    ].reject { |row, col| row.negative? || col.negative? }
  end
end

class OctopusFlashCounter
  attr_reader :flashes

  def initialize(octopus_grid)
    @octopus_grid = octopus_grid.map(&:chars).map.with_index do |row, row_number|
      row.map.with_index do |value, column_number|
        Octopus.new(row_number, column_number, value.to_i)
      end
    end

    @flashes = 0
  end

  def steps_until_all_flashing
    steps = 0

    until all_flashing?
      increase_energy!
      steps += 1
    end

    steps
  end

  def after_steps(number)
    1.upto(number) { increase_energy! }

    self
  end

  private

  def increase_energy!
    @octopus_grid.map { |row| row.map(&:increment!) }

    flashers_from(octopus_list: flashers)

    @flashes += flashers.size

    @octopus_grid.map { |row| row.map(&:reset!) }
  end

  def all_flashing?
    @octopus_grid.sum { |row| row.map(&:value).sum }.zero?
  end

  def flashers
    @octopus_grid.flatten.select(&:flashing?)
  end

  def flashers_from(octopus_list:, incremented: [])
    # Allows the method to be called with initial state and recursively
    incremented = octopus_list if incremented.empty?

    flashing_neighbors = octopus_list
                           .map do |octopus|
                             neighbors_of(octopus)
                               .reject { |octopus| incremented.include?(octopus) }
                               .map(&:increment!)
                               .select(&:flashing?)
                             end
                           .flatten
                           .uniq

    return if flashing_neighbors.empty?

    flashers_from(octopus_list: flashing_neighbors, incremented: incremented.concat(flashing_neighbors))
  end

  def octopus_from(row, column)
    @octopus_grid[row][column] || raise
  rescue
    Octopus.new(row, column)
  end

  def neighbors_of(octopus)
    octopus
      .neighbors
      .map { |neighbor_coords| octopus_from(*neighbor_coords) }
      .select { |octopus| octopus.valid?(row_max_index, column_max_index) }
  end

  def column_max_index
    @octopus_grid.first.size - 1
  end

  def row_max_index
    @octopus_grid.size - 1
  end
end

p(
  OctopusFlashCounter.new(File.readlines('input.txt', chomp: true))
    .steps_until_all_flashing
)
