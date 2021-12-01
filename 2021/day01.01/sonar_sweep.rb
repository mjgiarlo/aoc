p(
  File.readlines(
    File.expand_path('input.txt', __dir__),
    chomp: true
  )
    .map(&:to_i)
    .chunk_while do |x, y|
  y <= x
  end
    .to_a
    .drop(1)
    .size
)
