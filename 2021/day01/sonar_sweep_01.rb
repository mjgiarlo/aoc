p(
  File.foreach('input.txt')
    .map(&:to_i)
    .chunk_while { |x, y| y <= x }
    .drop(1)
    .size
)
