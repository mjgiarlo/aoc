p(
  File.foreach('input.txt')
    .map(&:to_i)
    .each_cons(3)
    .map(&:sum)
    .chunk_while { |x, y| y <= x }
    .drop(1)
    .size
)
