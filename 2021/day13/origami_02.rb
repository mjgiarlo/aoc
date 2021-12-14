Coordinates = Struct.new(:col, :row) do
  def adjust_rows_gt!(location)
    return if row < location

    self.row = (location * 2) - row
  end

  def adjust_cols_gt!(location)
    return if col < location

    self.col = (location * 2) - col
  end
end

class OrigamiFolder
  COORDINATES_DELIMITER = ','
  INSTRUCTION_DELIMITER = '='

  def initialize(lines)
    @dot_coordinates = lines
                         .select { |line| line.match?(COORDINATES_DELIMITER) }
                         .map { |coords_str| Coordinates.new(*coords_str.split(COORDINATES_DELIMITER).map(&:to_i)) }
                         .map { |coords| [coords, true] }
                         .to_h

    @instructions = lines
                      .select { |line| line.match?(INSTRUCTION_DELIMITER) }
                      .map { |instruction| instruction.delete_prefix('fold along ').split(INSTRUCTION_DELIMITER) }
  end

  def fold_per_instructions!
    @instructions.each { |axis, location| fold!(axis, location.to_i) }

    self
  end

  def render
    cols, rows = visible_dots.keys.map(&:to_a).transpose.map(&:max)
    grid = Array.new(rows + 1) { Array.new(cols + 1, '*') }
    visible_dots.keys.each do |coords|
      grid[coords.row][coords.col] = "\e[7m#\e[27m"
    end
    puts grid.map { |row| row.join(' ') }.join("\n")
  end

  private

  def visible_dots
    @dot_coordinates.select { |_, visible| visible }
  end

  def fold!(axis, location)
    if axis == 'y'
      @dot_coordinates.keys.filter_map { |coords| coords.adjust_rows_gt!(location) unless coords.row == location}
    else
      @dot_coordinates.keys.filter_map { |coords| coords.adjust_cols_gt!(location) unless coords.col == location}
    end
  end
end

OrigamiFolder.new(File.readlines('input.txt', chomp: true))
  .fold_per_instructions!
  .render
