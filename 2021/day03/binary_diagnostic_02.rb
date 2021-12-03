class Diagnosticator
  def initialize
    @diagnostics = []
  end

  def register(diagnostic)
    @diagnostics << diagnostic
  end

  def life_support
    oxygen_generator * carbon_dioxide_scrubber
  end

  private

  def oxygen_generator
    find_value do |count_comparison|
      case count_comparison
      when 0, -1  # There are more 1s or an equal number of 0s and 1s
        '1'
      when 1      # There are more 0s
        '0'
      end
    end
  end

  def carbon_dioxide_scrubber
    find_value do |count_comparison|
      case count_comparison
      when 0, -1  # There are more 1s or an equal number of 0s and 1s
        '0'
      when 1      # There are more 0s
        '1'
      end
    end
  end

  def find_value
    # We're using #delete_if to filter the diagnostics down, and that is a
    # mutator method, so make a copy first.
    candidates = @diagnostics.dup

    columns.times do |position|
      filter_value = yield value_count_comparison_by_position(candidates, position)
      candidates.select! { |diagnostic| diagnostic[position] == filter_value }

      return candidates.first.to_i(2) if candidates.size == 1
    end
  end

  def value_count_comparison_by_position(candidates, position)
    candidates
      .map(&:chars)
      .transpose
      .slice(position)
      .then do |position_values|
        # Would have been nice to use #max_by instead of this bit here but,
        # unfortunately, it doesn't help with our "in case of equal number of 0s
        # and 1s, return n" use case; it will return whichever occurs first. The
        # method does not allow for user-injectable tie-breaking strategies or
        # a default winning value.
        position_values.count('0') <=> position_values.count('1')
    end
  end

  def columns
    @diagnostics.first.size
  end
end

diagnosticator = Diagnosticator.new

File.foreach('input.txt', chomp: true) { |diagnostic| diagnosticator.register(diagnostic) }

p(diagnosticator.life_support)
