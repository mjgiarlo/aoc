Coordinates = Struct.new(:col1, :row1, :col2, :row2) do
  def vertical?
    col1 == col2
  end

  def horizontal?
    row1 == row2
  end

  def column_range
    [col1, col2].min..[col1, col2].max
  end

  def row_range
    [row1, row2].min..[row1, row2].max
  end

  def max
    [col1, col2, row1, row2].max
  end
end

class Navigator
  def initialize
    @coords = []
  end

  def add_coordinates(col1, row1, col2, row2)
    @coords << Coordinates.new(col1, row1, col2, row2)
  end

  def total_overlap_points
    @matrix = Array.new(size) { Array.new(size, 0) }
    @coords.each { |coordinates| mark_coordinates(coordinates) }
    @matrix.flatten.select { |touches| touches > 1 }.size
  end

  private

  def mark_coordinates(coordinates)
    if coordinates.vertical?
      @matrix.each.with_index do |row, i|
        next unless coordinates.row_range.include?(i)

        row[coordinates.col1] += 1
      end
    elsif coordinates.horizontal?
      @matrix[coordinates.row1][coordinates.column_range] = @matrix[coordinates.row1]
                                                              .slice(coordinates.column_range)
                                                              .map(&:next)
    end
  end

  def size
    @coords.map(&:max).max + 1
  end
end

navigator = Navigator.new

File.foreach('input.txt', chomp: true) do |range|
  col1, row1, col2, row2 = range
                     .split(' -> ')
                     .map { |coord| coord.split(',') }
                     .flatten
                     .map(&:to_i)

  navigator.add_coordinates(col1, row1, col2, row2)
end

p(navigator.total_overlap_points)
