p(File.readlines(File.expand_path('input.txt', __dir__), chomp: true).chunk_while do |x, y|
  x > y
end.to_a.size)
