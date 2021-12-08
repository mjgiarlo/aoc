crabs = File.readlines('input.txt', chomp: true)
          .first
          .split(',')
          .map(&:to_i)

positions = (crabs.min..crabs.max).to_a

relative_distances = positions.map do |position|
  [position, crabs.map { |crab| 1.upto((crab - position).abs).sum }.sum]
end.to_h

p(p(relative_distances).min_by { |position, distance| distance })
