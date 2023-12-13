MAX_POSSIBLE_CUBES = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}.freeze

Game = Struct.new(:id, :maxima) do
  def possible?
    maxima.all? { |color, count| count <= MAX_POSSIBLE_CUBES[color] }
  end
end

class GameParser
  def self.parse(input:)
    new(input:).parse
  end

  attr_reader :input

  def initialize(input:)
    @input = input
    @maxima = { 'red' => 0, 'green' => 0, 'blue' => 0 }
  end

  def parse
    calculate_maxima!
    Game.new(id, @maxima)
  end

  def id
    input.match(/Game (\d+):/).captures.first.to_i
  end

  def sets
    input.split(/[;:] /)[1..]
  end

  def calculate_maxima!
    sets.each do |set|
      set.split(/, /).each do |cube_count|
        count, color = cube_count.split
        @maxima.merge!({ color => count.to_i }) do |_color, existing_count, new_count|
          [existing_count, new_count].max
        end
      end
    end
  end
end

p(
  File
    .foreach('input.txt')
    .map { |line| GameParser.parse(input: line) }
    .select(&:possible?)
    .sum(&:id)
)
