calls = []
boards = []
board = nil

class Board
  def initialize
    @rows = []
  end

  def add_row(row)
    @rows << Hash[row.map { |value| [value, false] }]
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

File.foreach('input.txt', chomp: true).with_index do |line, i|
  if i.zero?
    calls = line.split(',')
    next
  end

  if line.empty?
    board = Board.new
    boards << board
    next
  end

  board.add_row(line.split)
end

calls.each do |call|
  boards.each do |board|
    board.mark(call)
    next unless board.winner?

    p(board.unmarked_sum * call.to_i)
    return
  end
end
