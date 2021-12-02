File.foreach('input.txt')
  .group_by { |direction| direction.split.first }
  .transform_values { |directions| directions.map { |direction| direction.split.last.to_i } }
  .tap { |moves| p(moves['forward'].sum * (moves['down'].sum - moves['up'].sum)) }
