p(File
  .readlines(File.expand_path('input.txt', __dir__), chomp: true)
  .each_cons(3)
  .map do |vals|
  vals.map(&:to_i).sum
end
  .chunk_while do |x, y|
    y <= x
  end.to_a.drop(1).size)
