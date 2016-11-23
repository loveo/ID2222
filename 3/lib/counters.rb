# Wrapper for node counters
class Counters

  def initialize
    @counters = {}
  end

  # Returns the counter for a specific item (node id)
  def get_counter(item)
    @counters[item] || create_counter(item)
  end

  # Checks if there where any changes made in this iteration
  def any_changes?
    @counter.empty? || @counter.values.any?(&:value_changed?)
  end

  # Applies any pending changes to each counter
  def apply_changes
    @counter.values.each(&:apply_changes)
  end

  private

  # Creates a counter for a specific item (id)
  def create_counter(item)
    @counters[item] = Counter.new.tap do |counter|
      counter.add(item)
    end
  end

end
