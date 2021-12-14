Coordinates = Struct.new(:col, :row)

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

  def after_folds(fold_number)
    1.upto(fold_number) { |i| fold!(i - 1) }

    self
  end

  def dots_count
    @dot_coordinates
      .select { |_, visible| visible }
      .count
  end

  private

  def fold!(instruction_number)
    axis, location = @instructions[instruction_number]
    location = location.to_i

    if axis == 'y'
      @dot_coordinates
        .reject { |coords, _| coords.row == location }
        .select { |coords, _| coords.row > location }
        .transform_keys { |coords, _| coords.row = (location * 2) - coords.row  }
    else
      @dot_coordinates
        .reject { |coords, _| coords.col == location }
        .select { |coords, _| coords.col > location }
        .transform_keys { |coords, _| coords.col = (location * 2) - coords.col  }
    end
  end
end

p(
  OrigamiFolder.new(File.readlines('input.txt', chomp: true))
    .after_folds(1)
    .dots_count
)
