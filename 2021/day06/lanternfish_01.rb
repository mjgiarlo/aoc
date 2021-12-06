class Lanternfish
  NEW_FISH = 8
  REFRACTORY_FISH = 6

  def initialize(initial_generation)
    @school = initial_generation
  end

  def after_generations(num)
    1.upto(num) { spawn! }

    self
  end

  def size
    @school.size
  end

  private

  def spawn!
    new_fish = 0

    @school.map! do |fish|
      if fish.zero?
        new_fish += 1
        REFRACTORY_FISH
      else
        fish - 1
      end
    end

    new_fish.times { @school << NEW_FISH }
  end
end

lanternfish = nil

File.foreach('input.txt', chomp: true) do |input|
  lanternfish = Lanternfish.new(input.split(',').map(&:to_i))
end

p(lanternfish.after_generations(80).size)
