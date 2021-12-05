class Board
  def initialize(rows)
    @rows = rows.map do |row|
      Hash[row.split.map { |value| [value, false] }]
    end
  end

  def mark(value)
    @rows.each do |row|
      row[value] = true if row.key?(value)
    end
  end

  def winner?
    @rows.map { |row| row.values.reduce { |memo, marked| memo && marked  } }.any? ||
      columns.map { |column| column.reduce { |memo, marked| memo && marked } }.any?
  end

  def unmarked_sum
    @rows.map { |row| row.select { |value, marked| marked == false }.keys.map(&:to_i).sum }.sum
  end

  private

  def columns
    @rows.map(&:values).transpose
  end
end

input = File.open('input.txt')
calls = input.readline.chomp.split(',')
boards = input
           .each(chomp: true)
           .reject(&:empty?)
           .each_slice(5)
           .map { |rows| Board.new(rows) }

calls.each do |call|
  boards.each do |board|
    board.mark(call)
    next unless board.winner?

    p(board.unmarked_sum * call.to_i)
    return
  end
end
