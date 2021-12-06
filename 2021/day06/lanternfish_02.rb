class Lanternfish
  NEW_FISH = 8
  REFRACTORY_FISH = 6
  RESET_FISH = -1

  def initialize(initial_generation)
    @school = initial_generation.reduce(Hash.new(0)) { |hash, value| hash[value] += 1; hash }
  end

  def after_generations(num)
    1.upto(num) { spawn! }

    self
  end

  def size
    @school.values.sum
  end

  private

  def spawn!
    @school.transform_keys! { |fish_state| fish_state - 1 }

    reset_fish = @school.delete(RESET_FISH)
    return unless reset_fish&.positive?

    @school[REFRACTORY_FISH] += reset_fish
    @school[NEW_FISH] = reset_fish
  end
end

lanternfish = nil

File.foreach('input.txt', chomp: true) do |input|
  lanternfish = Lanternfish.new(input.split(',').map(&:to_i))
end

p(lanternfish.after_generations(256).size)
