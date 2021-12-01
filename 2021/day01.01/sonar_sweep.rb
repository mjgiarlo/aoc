p(
  File.readlines(File.expand_path('input.txt', __dir__), chomp: true)
    .map(&:to_i)
    .chunk_while { |x, y| y <= x }
    .to_a
    .drop(1)
    .size
)
